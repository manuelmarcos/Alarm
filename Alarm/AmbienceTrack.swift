//
//  AmbienceTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 18/04/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation

class AmbienceTrack: AudioTrack {

    var fadeInDuration: Float

    init(type: AudioTrackType, fileName: String, startMinute: NSTimeInterval, length: Float, startVolume: Float, finishVolume: Float, numberOfLoops: NSInteger, fadeInDuration: Float) {
        self.fadeInDuration = fadeInDuration
        super.init(type: type, fileName: fileName, startMinute: startMinute, length: length, startVolume: startVolume, finishVolume: finishVolume, numberOfLoops: numberOfLoops)
    }

    func play(timer: NSTimer) {
        if let userInfo = timer.userInfo as? Dictionary<String, AnyObject>,
            let fadeToDuration: NSTimeInterval = userInfo["fadeToDuration"] as? NSTimeInterval {
            // set the fade in here
            self.audioPlayer!.fadeIn(fadeToDuration, fromVolume: self.startVolume, toVolume:self.finishVolume)
            self.audioPlayer?.play()
        }
    }
    func stop() {
        audioPlayer?.fadeIn(60, fromVolume: self.finishVolume, toVolume: 0.0)
    }
}
