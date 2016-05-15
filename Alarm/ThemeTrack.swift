//
//  ThemeTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 18/04/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation

class ThemeTrack: AudioTrack {

    func play(timer: NSTimer) {
        print("ThemeTrackPlay")
        if let userInfo = timer.userInfo as? Dictionary<String, AnyObject>,
            let fadeToDuration: NSTimeInterval = userInfo["fadeToDuration"] as? NSTimeInterval {
            // set the fade in here
            self.audioPlayer!.fadeIn(fadeToDuration, fromVolume: self.startVolume, toVolume:self.finishVolume)
            self.audioPlayer?.play()
        }
    }

    func playNow() {
        print("ThemeTrackPlayNow")
        self.audioPlayer?.play()
    }

}
