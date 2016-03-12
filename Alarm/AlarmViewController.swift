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
        
        let trackAmbient: AudioTrack = AudioTrack(type: AudioTrackType.Ambient, fileName: "ambient1.mp3", startMinute: NSTimeInterval(0), startVolume: 3, finishVolume: 4)
        let trackTheme: AudioTrack = AudioTrack(type: AudioTrackType.Theme, fileName: "theme1.mp3", startMinute: NSTimeInterval(3 * 60), startVolume: 3, finishVolume: 4)
        let trackVoice: AudioTrack = AudioTrack(type: AudioTrackType.Voice, fileName: "voice1.mp3", startMinute: NSTimeInterval(6 * 60), startVolume: 3, finishVolume: 4)
        self.alarm = Alarm(ambient: trackAmbient, theme: trackTheme, voice: trackVoice, totalTime: NSTimeInterval(9 * 60))
    }
    
    @IBAction func setAlarmAction(sender: AnyObject) {

        // FIXME: This is a quick solution in order to send a build out
        var currentDate = NSDate();
        let timeInterval = floor(currentDate.timeIntervalSinceReferenceDate / 60.0) * 60.0
        currentDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
        var pickerDate = NSDate();
        let pickerTimeInterval = floor(datePicker.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
        pickerDate = NSDate(timeIntervalSinceReferenceDate: pickerTimeInterval)
        if (pickerDate.isEqualToDate(currentDate)) {
            AlertsUtils.showAlertWithErrorMessage("Cannot set alarm. Try setting alarm one minute ahead")
        } else {
            alarm?.setAlarmDate(pickerDate)
            self.alarmLabel.text = "Alarm set \(pickerDate))"
        }
    }    
    
    @IBAction func stop(sender: AnyObject) {
        alarm?.stop()
    }
}

