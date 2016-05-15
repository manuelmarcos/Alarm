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

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }
}

class AlarmViewController: UIViewController, ConfigurationAlarm {
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var setButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var alarmFileNamesLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    var alarm: Alarm?
    var currentDim: CGFloat?

    func configurationAlarm(alarm: Alarm) {
        self.alarm = alarm
        if self.alarm?.ambient.fileName != nil &&  self.alarm?.theme.fileName != nil {
            self.alarmFileNamesLabel.text = "Ambience Track: \((self.alarm?.ambient.fileName)!) Theme trach: \((self.alarm?.theme.fileName)!)"

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmLabel.text = "no alarm set"
        self.alarmFileNamesLabel.text = "Ambience Track: birdies.mp3; Theme track: theme1.mp3"
        self.currentDim = UIScreen.mainScreen().brightness
        datePicker.timeZone = NSTimeZone.localTimeZone()




        // Debugging code
        let trackAmbient: AmbienceTrack = AmbienceTrack(type: AudioTrackType.Ambient, fileName:"birdies.mp3", startMinute:NSTimeInterval(1 * 60), length:0, startVolume:0.01, finishVolume:0.95, numberOfLoops:-1, fadeInDuration: 0.0)
        let trackTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Ambient, fileName:"theme1.mp3", startMinute:NSTimeInterval(1 * 60), length:0, startVolume:0.01, finishVolume:0.95, numberOfLoops:0)
        let trackLoopTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Theme, fileName:"theme1Loop.mp3", startMinute:0, length:0, startVolume:0.95, finishVolume:0.95, numberOfLoops:-1)
        alarm = Alarm(ambient: trackAmbient, theme: trackTheme, loopTheme: trackLoopTheme)

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

        // Debugging
        //        let pickerTimeInterval = floor(datePicker.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
        //        alarm?.setAlarmDate(NSDate(timeIntervalSinceReferenceDate: pickerTimeInterval))

        if alarm != nil {
            var currentDate = NSDate()
            let timeInterval = floor(currentDate.timeIntervalSinceReferenceDate / 60.0) * 60.0
            currentDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)

            var pickerDate = NSDate()
            let pickerTimeInterval = floor(datePicker.date.timeIntervalSinceReferenceDate / 60.0) * 60.0
            pickerDate = NSDate(timeIntervalSinceReferenceDate: pickerTimeInterval)
            if (pickerDate.isEqualToDate(currentDate) || currentDate.isGreaterThanDate(pickerDate)) {
                AlertsUtils.showAlertWithErrorMessage("Cannot set alarm. Try setting alarm one minute ahead of your current time")
            } else {
                self.alarmLabel.text = "Alarm set \(pickerDate.descriptionWithLocale(NSLocale.systemLocale())))"
                self.setButton.enabled = false
                alarm?.setAlarmDate(pickerDate)
            }
        } else {
            AlertsUtils.showAlertWithErrorMessage("You first need to configure an alarm.")
        }
    }

    @IBAction func stop(sender: AnyObject) {
        self.alarmLabel.text = "no alarm set"
        alarm?.stop()
        self.setButton.enabled = true
    }

    @IBAction func SwitchChangedAction(sender: UISwitch) {
        UIScreen.mainScreen().brightness = (sender.on) ? 0 : self.currentDim!
        self.view.backgroundColor = (sender.on) ? UIColor.blackColor() : UIColor.whiteColor()
    }

}
