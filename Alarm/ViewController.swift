//
//  ViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 01/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit
import AudioPlayer

class ViewController: UIViewController {
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var alarmDate: NSDate?
    var audioPlayer: AudioPlayer?
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setAlarm(sender: AnyObject) {
        
        if (self.audioPlayer?.playing == true) {
            self.audioPlayer?.stop()
        }
        
        if (self.timer != nil) {
            self.timer?.invalidate()
        }

        UIApplication.sharedApplication().idleTimerDisabled = true

        print(datePicker.date)
        alarmDate = datePicker.date
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
}

