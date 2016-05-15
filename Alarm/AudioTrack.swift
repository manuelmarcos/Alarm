//
//  AudioTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation

enum AudioTrackType {
    case Ambient
    case Theme
    case Voice
}

class AudioTrack: NSObject {
    var audioTrackType: AudioTrackType // we might not ever need this but useful if instrospection is needed
    var fileName: String
    var startMinute: NSTimeInterval
    var lengthTrack: Float
    var startVolume: Float
    var finishVolume: Float
    var audioPlayer: AudioPlayerManager?
    var timer: NSTimer?
    var numberOfLoops: NSInteger

    init(type: AudioTrackType, fileName: String, startMinute: NSTimeInterval, length: Float, startVolume: Float, finishVolume: Float, numberOfLoops: NSInteger) {
        self.audioTrackType = type
        self.fileName = fileName
        self.startMinute = startMinute
        self.lengthTrack = length
        self.startVolume = startVolume
        self.finishVolume = finishVolume
        self.numberOfLoops = numberOfLoops
        do {
            self.audioPlayer = try AudioPlayerManager(fileName:fileName)
            self.audioPlayer?.numberOfLoops = numberOfLoops // -1 Will loop indefinitely until stopped.
            self.audioPlayer?.volume = self.startVolume
        } catch {
            print("oh-oh")
        }
    }
}
