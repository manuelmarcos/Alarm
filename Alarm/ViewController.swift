//
//  ViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 01/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit
import AudioPlayer
import MediaPlayer

class ViewController: UIViewController {
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var audioPlayer: AudioPlayer?
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setAlarm(sender: AnyObject) {
        
        self.setSystemSettings()
        
        if (self.audioPlayer?.playing == true) {
            self.audioPlayer?.stop()
        }
        
        if (self.timer != nil) {
            self.timer?.invalidate()
        }

        print(datePicker.date)
        self.timer = NSTimer(fireDate: datePicker.date, interval: 0, target: self, selector: "playAlarm", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.alarmLabel.text = "Alarm set \(datePicker.date)"
    }
    
    func playAlarm() {
        do {
            self.audioPlayer = try AudioPlayer(fileName:"wakeapp.mp3")
            // Start playing
            self.audioPlayer!.play()
            // Let the phone go to sleep if needed
            UIApplication.sharedApplication().idleTimerDisabled = false
        } catch {
            print("oh-oh")
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        if (self.audioPlayer?.playing == true) {
            self.audioPlayer?.stop()
        }
        if (self.timer != nil) {
            self.timer?.invalidate()
        }
        // Let the phone go to sleep if needed
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    func setSystemSettings() {
        UIApplication.sharedApplication().idleTimerDisabled = true
        self.setSystemVolume(10)
        // UIScreen.mainScreen().brightness = 0.0
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

