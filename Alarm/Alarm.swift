//
//  Alarm.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import AudioPlayer
import MediaPlayer

class Alarm: NSObject {
    var ambient: AudioTrack
    var theme: AudioTrack
    var voice: AudioTrack
    var totalTime: Float
    var timer: NSTimer?

    init(ambient: AudioTrack, theme: AudioTrack, voice: AudioTrack, totalTime: Float) {
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
        
        if (self.timer != nil) {
            self.timer?.invalidate()
        }
        
        self.timer = NSTimer(fireDate: dateSet, interval: 0, target: self, selector: "playAlarm", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    func playAlarm() {
        self.ambient.audioPlayer?.play()
        self.theme.audioPlayer?.play()
        self.voice.audioPlayer?.play()
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
       
        if (self.timer != nil) {
            self.timer?.invalidate()
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