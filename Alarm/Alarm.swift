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
    var loopTheme: ThemeTrack
    var stopAmbienceTimer: NSTimer?

    init(ambient: AmbienceTrack, theme: ThemeTrack, loopTheme: ThemeTrack) {
        self.ambient = ambient
        self.theme = theme
        self.loopTheme = loopTheme
    }

    func setAlarmDate(dateSet: NSDate) {
        self.setSystemSettings(forAlarmOn: true)

        if (self.playing() == true) {
            self.stop()
        }
        // This method would stop the ambience sound by doing a fadeout
        let ambiencefadeOutStartMinute = Double((self.ambient.lengthTrack * 60) - (self.theme.fadeInDuration / 2))
        self.stopAmbienceTimer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(ambiencefadeOutStartMinute), interval: 0, target: self.ambient, selector: #selector(self.ambient.stop), userInfo: ["fadeToDuration" : (self.theme.fadeInDuration / 2)], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.stopAmbienceTimer!, forMode: NSRunLoopCommonModes)

        // TODO: Move this to the set method of timer for each ambient
        self.ambient.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(0), interval: 0.0, target: self.ambient, selector:#selector(self.ambient.play), userInfo: ["fadeToDuration" : self.ambient.fadeInDuration], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.ambient.timer!, forMode: NSRunLoopCommonModes)

          self.theme.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(ambiencefadeOutStartMinute), interval: 0.0, target: self.theme, selector: #selector(self.theme.play), userInfo: ["fadeToDuration" : self.theme.fadeInDuration], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.theme.timer!, forMode: NSRunLoopCommonModes)

        if let durationTrack: NSTimeInterval = self.theme.audioPlayer?.duration {
            self.loopTheme.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(Double(self.ambient.lengthTrack)  + durationTrack), interval: 0.0, target: self.loopTheme, selector: #selector(self.loopTheme.playNow), userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.loopTheme.timer!, forMode: NSRunLoopCommonModes)
        }
}

    func playing() -> Bool {
        return (self.ambient.audioPlayer?.playing == true ||
            self.theme.audioPlayer?.playing == true)
    }

    func stop() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.ambient.audioPlayer?.stop()
        self.theme.audioPlayer?.stop()
        self.loopTheme.audioPlayer?.stop()

        if (self.ambient.timer != nil &&
            self.theme.timer != nil &&
            self.loopTheme.timer != nil &&
            self.stopAmbienceTimer != nil) {

            self.ambient.timer?.invalidate()
            self.ambient.timer = nil
            self.theme.timer?.invalidate()
            self.theme.timer = nil
            self.loopTheme.timer?.invalidate()
            self.loopTheme.timer = nil
            self.stopAmbienceTimer?.invalidate()
            self.stopAmbienceTimer = nil
        }
    }

    func setSystemSettings(forAlarmOn isAlarmOn: Bool) {
        UIApplication.sharedApplication().idleTimerDisabled = isAlarmOn
        self.setSystemVolume((isAlarmOn) ? 0.85 : 0)
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
