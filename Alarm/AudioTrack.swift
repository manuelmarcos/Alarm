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
    var audioPlayer: AudioPlayerManager?
    var timer: NSTimer?

    init(type: AudioTrackType, fileName: String, startMinute: NSTimeInterval, startVolume: Float, finishVolume: Float) {
        self.audioTrackType = type
        self.fileName = fileName
        self.startMinute = startMinute
        self.startVolume = startVolume
        self.finishVolume = finishVolume
        do {
            self.audioPlayer = try AudioPlayerManager(fileName:fileName)
            self.audioPlayer?.numberOfLoops = -1 // Will loop indefinitely until stopped.
            self.audioPlayer?.volume = self.startVolume
        } catch {
            print("oh-oh")
        }
    }
    
    func play(timer: NSTimer) {
       if let userInfo = timer.userInfo as? Dictionary<String, AnyObject>,
        let fadeToDuration: NSTimeInterval = userInfo["fadeToDuration"] as? NSTimeInterval {
        // set the fade in here
        self.audioPlayer!.fadeIn(fadeToDuration, fromVolume: self.startVolume, toVolume:self.finishVolume)
        self.audioPlayer?.play()
        }
    }
}
