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
    var ambient: AudioTrack
    var theme: AudioTrack
    var voice: AudioTrack
    var totalTime: NSTimeInterval
    var timer: NSTimer?

    init(ambient: AudioTrack, theme: AudioTrack, voice: AudioTrack, totalTime: NSTimeInterval) {
        self.ambient = ambient
        self.theme = theme
        self.voice = voice
        self.totalTime = totalTime
    }

    func setAlarmDate(dateSet: NSDate) {
        self.setSystemSettings(forAlarmOn: true)

        if (self.playing() == true) {
            self.stop()
        }

        // This method would stop the alarm at the dateSet plus the alarm totaltime
        //self.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(self.totalTime), interval: 0, target: self, selector: #selector(Alarm.stop), userInfo: nil, repeats: false)
        //NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)

        // TODO: Move this to the set method of timer for each ambient
        self.ambient.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(self.ambient.startMinute), interval: 0.0, target: self.ambient, selector: #selector(self.ambient.play), userInfo: ["fadeToDuration" : (self.totalTime - self.ambient.startMinute)], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.ambient.timer!, forMode: NSRunLoopCommonModes)



        self.theme.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(self.theme.startMinute), interval: 0.0, target: self.theme, selector: #selector(self.theme.play), userInfo: ["fadeToDuration" : (self.totalTime - self.theme.startMinute)], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.theme.timer!, forMode: NSRunLoopCommonModes)



        self.voice.timer = NSTimer(fireDate: dateSet.dateByAddingTimeInterval(self.voice.startMinute), interval: 0.0, target: self.voice, selector:#selector(self.voice.play), userInfo: ["fadeToDuration" : (self.totalTime - self.voice.startMinute)], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.voice.timer!, forMode: NSRunLoopCommonModes)


}

    func playing() -> Bool {
        return (self.ambient.audioPlayer?.playing == true ||
            self.theme.audioPlayer?.playing == true ||
            self.voice.audioPlayer?.playing == true)
    }

    func stop() {
        self.ambient.audioPlayer?.stop()
        self.theme.audioPlayer?.stop()
        self.voice.audioPlayer?.stop()

        if (self.ambient.timer != nil &&
            self.theme.timer != nil &&
            self.voice.timer != nil &&
            self.timer != nil) {


                self.ambient.timer?.invalidate()
                self.ambient.timer = nil
                self.theme.timer?.invalidate()
                self.theme.timer = nil
                self.voice.timer?.invalidate()
                self.voice.timer = nil
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
