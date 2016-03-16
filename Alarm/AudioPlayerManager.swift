//
//  AudioPlayerManager.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 16/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import AVFoundation

public enum AudioPlayerManagerError: ErrorType {
    case FileExtension
}

public class AudioPlayerManager: NSObject {
    
    public static let SoundDidFinishPlayingNotification = "SoundDidFinishPlayingNotification"
    public typealias SoundCompletionHandler = (didFinish: Bool) -> Void
    
    /// Name of the used to initialize the object
    public var name: String?
    
    /// URL of the used to initialize the object
    public let URL: NSURL?
    
    /// A callback closure that will be called when the audio finishes playing, or is stopped.
    public var completionHandler: SoundCompletionHandler?
    
    /// is it playing or not?
    public var playing: Bool {
        get {
            if let nonNilsound = sound {
                return nonNilsound.playing
            }
            return false
        }
    }
    
    /// the duration of the sound.
    public var duration: NSTimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.duration
            }
            return 0.0
        }
    }
    
    /// currentTime is the offset into the sound of the current playback position.
    public var currentTime: NSTimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.currentTime
            }
            return 0.0
        }
        set {
            sound?.currentTime = newValue
        }
    }
    
    /// The volume for the sound. The nominal range is from 0.0 to 1.0.
    public var volume: Float = 1.0 {
        didSet {
            volume = min(1.0, max(0.0, volume));
            targetVolume = volume
        }
    }
    
    /// "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
    /// A value of zero means to play the sound just once.
    /// A value of one will result in playing the sound twice, and so on..
    /// Any negative number will loop indefinitely until stopped.
    public var numberOfLoops: Int = 0 {
        didSet {
            sound?.numberOfLoops = numberOfLoops
        }
    }
    
    /// set panning. -1.0 is left, 0.0 is center, 1.0 is right.
    public var pan: Float = 0.0 {
        didSet {
            sound?.pan = pan
        }
    }
    
    // MARK: Init
    
    public convenience init(fileName: String) throws {
        let fixedFileName = fileName.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        var soundFileComponents = fixedFileName.componentsSeparatedByString(".")
        if soundFileComponents.count == 1 {
            throw AudioPlayerManagerError.FileExtension
        }
        let path = NSBundle.mainBundle().pathForResource(soundFileComponents[0], ofType: soundFileComponents[1])
        try self.init(contentsOfPath: path!)
    }
    
    public convenience init(contentsOfPath path: String) throws {
        let fileURL = NSURL(fileURLWithPath: path)
        try self.init(contentsOfURL: fileURL)
    }
    
    public init(contentsOfURL URL: NSURL) throws {
        self.URL = URL
        name = URL.lastPathComponent
        sound = try? AVAudioPlayer(contentsOfURL: URL)
        super.init()
        
        sound?.delegate = self
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: Play / Stop
    
    public func play() {
        if playing == false {
            sound?.play()
        }
    }
    
    public func stop() {
        if playing {
            soundDidFinishPlayingSuccessfully(false)
        }
    }
    
    // MARK: Fade
    
    public func fadeTo(volume: Float, duration: NSTimeInterval = 1.0) {
        startVolume = volume;
        fadeTime = duration;
        fadeStart = NSDate().timeIntervalSinceReferenceDate
        if timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.015, target: self, selector: "handleFadeTo", userInfo: nil, repeats: true)
        }
    }
    
    public func fadeIn(duration: NSTimeInterval = 1.0) {
        volume = 0.0
        fadeTo(1.0, duration: duration)
    }
    
    public func fadeIn(duration: NSTimeInterval = 1.0, fromVolume: Float, toVolume: Float) {
        targetVolume = toVolume
        fadeTo(fromVolume, duration: duration)
    }

    public func fadeOut(duration: NSTimeInterval = 1.0) {
        fadeTo(0.0, duration: duration)
    }
    
    // MARK: Private
    
    @objc private func handleFadeTo() {
        let now = NSDate().timeIntervalSinceReferenceDate
        let delta: Float = (Float(now - fadeStart) / Float(fadeTime) * (targetVolume - startVolume))
        sound?.volume = startVolume + delta
        print("\(sound?.volume)")
        if delta > 0.0 && sound?.volume >= targetVolume ||
            delta < 0.0 && sound?.volume <= targetVolume {
                sound?.volume = targetVolume
                timer?.invalidate()
                timer = nil
                if sound?.volume == 0 {
                    stop()
                }
        }
    }
    
    // MARK: Private properties
    
    private let sound: AVAudioPlayer?
    private var startVolume: Float = 1.0
    private var targetVolume: Float = 1.0 {
        didSet {
            sound?.volume = targetVolume
        }
    }
    
    private var fadeTime: NSTimeInterval = 0.0
    private var fadeStart: NSTimeInterval = 0.0
    private var timer: NSTimer?
    
}

extension AudioPlayerManager: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        soundDidFinishPlayingSuccessfully(flag)
    }
    
}

private extension AudioPlayerManager {
    
    private func soundDidFinishPlayingSuccessfully(didFinishSuccessfully: Bool) {
        sound?.stop()
        timer?.invalidate()
        timer = nil
        
        if let nonNilCompletionHandler = completionHandler {
            nonNilCompletionHandler(didFinish: didFinishSuccessfully)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(AudioPlayerManager.SoundDidFinishPlayingNotification, object: self)
    }
    
}
