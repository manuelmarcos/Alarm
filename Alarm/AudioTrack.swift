//
//  AudioTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import AudioPlayer

enum AudioTrackType {
    case Ambient
    case Theme
    case Voice
}

class AudioTrack: NSObject {
    var audioTrackType: AudioTrackType // we might not ever need this but useful if instrospection is needed
    var fileName: String
    var startMinute: NSTimeInterval
    var startVolume: Float
    var finishVolume: Float
    var audioPlayer: AudioPlayer?
    var timer: NSTimer?

    init(type: AudioTrackType, fileName: String, startMinute: NSTimeInterval, startVolume: Float, finishVolume: Float) {
        self.audioTrackType = type
        self.fileName = fileName
        self.startMinute = startMinute
        self.startVolume = startVolume
        self.finishVolume = finishVolume
        do {
            self.audioPlayer = try AudioPlayer(fileName:fileName)
            self.audioPlayer?.numberOfLoops = -1 // Will loop indefinitely until stopped.
        } catch {
            print("oh-oh")
        }
    }
}
