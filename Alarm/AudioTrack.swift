//
//  AudioTrack.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import AudioPlayer

class AudioTrack: NSObject {
    enum Type {
        case Ambient
        case Theme
        case Voice
    }
    var fileName: String
    var startMinute: Float
    var startVolume: Float
    var finishVolume: Float
    var audioPlayer: AudioPlayer?
    
    init(fileName: String, startMinute: Float, startVolume: Float, finishVolume: Float) {
        self.fileName = fileName
        self.startMinute = startMinute
        self.startVolume = startVolume
        self.finishVolume = finishVolume
        do {
            self.audioPlayer = try AudioPlayer(fileName:fileName)
        } catch {
            print("oh-oh")
        }
    }
}
