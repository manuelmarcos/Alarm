//
//  Alarm.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import MediaPlayer

class Alarm: NSObject {
    var ambient: AmbienceTrack
    var theme: ThemeTrack
    var loopTheme: ThemeTrack?
    var stopAmbienceTimer: NSTimer?

    init(ambient: AmbienceTrack, theme: ThemeTrack) {
        self.ambient = ambient
        self.theme = theme
    }

    func setAlarmDate(dateSet: NSDate) {
        self.setSystemSettings(forAlarmOn: true)

        if (self.playing() == true) {
            self.stop()
        }

        // This method would stop the ambience sound by doing a fadeout
        self.stopAmbienceTimer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval((2 * 60) - 30), interval: 0, target: self.ambient, selector: #selector(self.ambient.stop), userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.stopAmbienceTimer!, forMode: NSRunLoopCommonModes)

        // TODO: Move this to the set method of timer for each ambient
        self.ambient.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(0), interval: 0.0, target: self.ambient, selector:#selector(self.ambient.play), userInfo: ["fadeToDuration" : 60], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.ambient.timer!, forMode: NSRunLoopCommonModes)

          self.theme.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval((2 * 60) - 15), interval: 0.0, target: self.theme, selector: #selector(self.theme.play), userInfo: ["fadeToDuration" : 30], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.theme.timer!, forMode: NSRunLoopCommonModes)



        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.stopTheme), name: AudioPlayerManager.SoundDidFinishPlayingNotification, object: nil)



}

    func stopTheme(notification: NSNotification) {

        print("stopTheme")

        if (self.ambient.audioPlayer?.playing == false && self.theme.audioPlayer?.playing == false) {
            self.loopTheme = ThemeTrack(type: AudioTrackType.Theme, fileName:"theme1Loop.mp3", startMinute:0, startVolume:0.8, finishVolume:0.8, numberOfLoops:-1)
            self.loopTheme!.playNow()
        }


    }


    func playing() -> Bool {
        return (self.ambient.audioPlayer?.playing == true ||
            self.theme.audioPlayer?.playing == true)
    }

    func stop() {
        self.ambient.audioPlayer?.stop()
        self.theme.audioPlayer?.stop()
        if self.loopTheme?.audioPlayer != nil {
            self.loopTheme!.audioPlayer?.stop()
        }

        if (self.ambient.timer != nil &&
            self.theme.timer != nil &&
            self.stopAmbienceTimer != nil) {


                self.ambient.timer?.invalidate()
                self.ambient.timer = nil
                self.theme.timer?.invalidate()
                self.theme.timer = nil
        }
    }

    func setSystemSettings(forAlarmOn isAlarmOn: Bool) {
        UIApplication.sharedApplication().idleTimerDisabled = isAlarmOn
        self.setSystemVolume((isAlarmOn) ? 10 : 0)
        // UIScreen.mainScreen().brightness = (isAlarmOn) ? 10 : 0
    }

    func setSystemVolume(volume: Float) {
        let volumeView = MPVolumeView()

        for view in volumeView.subviews {
            if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
                let slider = view as! UISlider
                slider.setValue(volume, animated: false)
            }
        }
    }
}
