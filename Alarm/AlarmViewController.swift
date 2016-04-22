//
//  AlarmViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 01/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

protocol ConfigurationAlarm {
    func configurationAlarm(alarm: Alarm)
}

import UIKit

class AlarmViewController: UIViewController, ConfigurationAlarm {
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var alarm: Alarm?

    func configurationAlarm(alarm: Alarm) {
        self.alarm = alarm
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.timeZone = NSTimeZone.localTimeZone()

        // TODO: remove the set alarm here
        let trackAmbient: AmbienceTrack = AmbienceTrack(type: AudioTrackType.Ambient, fileName:"birdies.mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.1, finishVolume:0.9, numberOfLoops:-1)
        let trackTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Ambient, fileName:"theme1.mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.1, finishVolume:0.8, numberOfLoops:0)
        alarm = Alarm(ambient: trackAmbient, theme: trackTheme)
    }

    @IBAction func configureAction(sender: AnyObject) {
        if alarm != nil {
            alarm?.stop()
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let configureNavigationController: UINavigationController = mainStoryboard.instantiateViewControllerWithIdentifier("ConfigureViewController") as! UINavigationController
        let array = configureNavigationController.viewControllers
        let configureController: ConfigureViewController = array[0] as! ConfigureViewController
        configureController.delegate  = self
        self.presentViewController(configureNavigationController, animated: true, completion: nil)
    }

    @IBAction func setAlarmAction(sender: AnyObject) {


#if DEBUG
    // Debugging code
    let trackAmbient: AmbienceTrack = AmbienceTrack(type: AudioTrackType.Ambient, fileName:"birdies.mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.1, finishVolume:0.9, numberOfLoops:-1)
    let trackTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Ambient, fileName:"theme1.mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.1, finishVolume:0.8, numberOfLoops:0)
        alarm = Alarm(ambient: trackAmbient, theme: trackTheme)
        let pickerTimeInterval = floor(datePicker.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
        alarm?.setAlarmDate(NSDate(timeIntervalSinceReferenceDate: pickerTimeInterval))

#else
        // Production code
        if alarm != nil {
            var currentDate = NSDate()
            let timeInterval = floor(currentDate.timeIntervalSinceReferenceDate / 60.0) * 60.0
            currentDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)

            var pickerDate = NSDate()
            let pickerTimeInterval = floor(datePicker.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
            pickerDate = NSDate(timeIntervalSinceReferenceDate: pickerTimeInterval)
            if (pickerDate.isEqualToDate(currentDate) ) {
                AlertsUtils.showAlertWithErrorMessage("Cannot set alarm. Try setting alarm one minute ahead")
            } else {
                alarm?.setAlarmDate(pickerDate)
                self.alarmLabel.text = "Alarm set \(pickerDate))"
            }
        } else {
            AlertsUtils.showAlertWithErrorMessage("You first need to configure an alarm.")
        }
#endif

    }

    @IBAction func stop(sender: AnyObject) {
        alarm?.stop()
    }

    @IBAction func SwitchChangedAction(sender: UISwitch) {
        UIScreen.mainScreen().brightness = (sender.on) ? 0 : 10
    }

}
