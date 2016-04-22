//
//  AmbienceTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 18/04/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation

class AmbienceTrack: AudioTrack {

    func play(timer: NSTimer) {
        if let userInfo = timer.userInfo as? Dictionary<String, AnyObject>,
            let fadeToDuration: NSTimeInterval = userInfo["fadeToDuration"] as? NSTimeInterval {
            // set the fade in here
            self.audioPlayer!.fadeIn(fadeToDuration, fromVolume: self.startVolume, toVolume:self.finishVolume)
            self.audioPlayer?.play()
        }
    }
    func stop() {
        audioPlayer?.fadeIn(30, fromVolume: 0.8, toVolume: 0.0)
    }
}
