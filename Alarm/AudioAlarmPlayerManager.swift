//
//  AudioAlarmPlayerManager.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation

class AudioAlarmPlayerManager: NSObject {
    var ambient: AudioTrack
    var theme: AudioTrack
    var voice: AudioTrack
    var totalTime: Float
    
    init(ambient: AudioTrack, theme: AudioTrack, voice: AudioTrack, totalTime: Float) {
        self.ambient = ambient
        self.theme = theme
        self.voice = voice
        self.totalTime = totalTime
    }
    
    
}