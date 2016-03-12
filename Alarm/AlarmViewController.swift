//
//  AlarmViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 01/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var alarm: Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackAmbient: AudioTrack = AudioTrack(type: AudioTrackType.Ambient, fileName: "ambient1.mp3", startMinute: 3, startVolume: 3, finishVolume: 4)
        let trackTheme: AudioTrack = AudioTrack(type: AudioTrackType.Theme, fileName: "theme1.mp3", startMinute: 3, startVolume: 3, finishVolume: 4)
        let trackVoice: AudioTrack = AudioTrack(type: AudioTrackType.Voice, fileName: "voice1.mp3", startMinute: 3, startVolume: 3, finishVolume: 4)
        self.alarm = Alarm(ambient: trackAmbient, theme: trackTheme, voice: trackVoice, totalTime: 30)
    }
    
    @IBAction func setAlarmAction(sender: AnyObject) {
        alarm?.setAlarmDate(datePicker.date)
        self.alarmLabel.text = "Alarm set \(datePicker.date)"
    }    
    
    @IBAction func stop(sender: AnyObject) {
        alarm?.stop()
    }
}

