//
//  ConfigureViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import UIKit

extension Float {
    var cleanValue: String {
        return String(format: "%.0f", self)
    }
}

class ConfigureViewController: UIViewController {
    @IBOutlet var ambientSegmentedControl: UISegmentedControl!
    @IBOutlet var themeSegmentedControl: UISegmentedControl!
    @IBOutlet var ambienceVolumeSlider: UISlider!
    @IBOutlet var ambienceVolumeLabel: UILabel!
    @IBOutlet var themeVolumeSlider: UISlider!
    @IBOutlet var themeVolumeLabel: UILabel!
    @IBOutlet var ambienceTimeSlider: UISlider!
    @IBOutlet var ambienceTimeLabel: UILabel!
    @IBOutlet var ambienceFadeInSlider: UISlider!
    @IBOutlet var ambienceFadeInLabel: UILabel!
    @IBOutlet var crossfadeSlider: UISlider!
    @IBOutlet var crossfadeLabel: UILabel!

    var audioPlayer: AudioPlayerManager?

    var delegate: ConfigurationAlarm!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(ConfigureViewController.doneAction)), animated: false)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(ConfigureViewController.cancelAction)), animated: false)

        self.ambientSegmentedControl.setTitle("birdies", forSegmentAtIndex: 0)
        self.ambientSegmentedControl.setTitle("canyon", forSegmentAtIndex: 1)
        self.ambientSegmentedControl.setTitle("woodenChime", forSegmentAtIndex: 2)

        self.themeSegmentedControl.setTitle("theme1", forSegmentAtIndex: 0)
        self.themeSegmentedControl.setTitle("theme2", forSegmentAtIndex: 1)
        self.themeSegmentedControl.setTitle("theme3", forSegmentAtIndex: 2)
    }

    @IBAction func crossfadeValueChanged(sender: AnyObject) {
        self.crossfadeLabel.text = "Crossfade \(self.crossfadeSlider.value.cleanValue) seconds"
    }

    @IBAction func ambienceFadeInValueChanged(sender: AnyObject) {
        let rounded = round(self.ambienceFadeInSlider.value)
        self.ambienceFadeInLabel.text = "Fade In Ambience Time \(rounded.cleanValue) minute"

    }

    @IBAction func ambienceFadeInTouchUpInsideAction(sender: AnyObject) {
        let rounded = round(self.ambienceFadeInSlider.value)
        self.ambienceFadeInSlider.setValue(rounded, animated: true)


        if self.crossfadeSlider.value > ((self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60) {
            self.crossfadeSlider.value = (self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60
            self.crossfadeLabel.text = "Crossfade \(self.crossfadeSlider.value.cleanValue) seconds"
        }
        self.crossfadeSlider.maximumValue = (self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60

    }

    @IBAction func ambienteTimeValueChanged(sender: AnyObject) {
        let rounded = round(self.ambienceTimeSlider.value)
        self.ambienceTimeLabel.text = "Ambience time \(rounded.cleanValue) minute"
    }

    @IBAction func ambienteTimeTouchUpInsideAction(sender: AnyObject) {
        let rounded = round(self.ambienceTimeSlider.value)
        self.ambienceTimeSlider.setValue(rounded, animated: true)

        if self.ambienceFadeInSlider.value > self.ambienceTimeSlider.value - 1 {
            self.ambienceFadeInSlider.value = self.ambienceTimeSlider.value - 1
            let rounded = round(self.ambienceFadeInSlider.value)
            self.ambienceFadeInLabel.text = "Fade In Ambience Time \(rounded.cleanValue) minute"
        }
        // The maximun value of the fade in will be the value of the ambience time, in other words it will bethe lenght of the track
        self.ambienceFadeInSlider.maximumValue = self.ambienceTimeSlider.value - 1

        if self.crossfadeSlider.value > ((self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60) {
            self.crossfadeSlider.value = (self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60
            self.crossfadeLabel.text = "Crossfade \(self.crossfadeSlider.value.cleanValue) seconds"
        }
        self.crossfadeSlider.maximumValue = (self.ambienceTimeSlider.value - self.ambienceFadeInSlider.value) * 60
    }

    @IBAction func ambienteVolumeValueChangedAction(sender: AnyObject) {
        let floatSlideValue = (self.ambienceVolumeSlider.value * 100) / 1
        self.ambienceVolumeLabel.text = "Ambience Volume \(floatSlideValue.cleanValue)%"
    }

    @IBAction func themeVolumeValueChangedAction(sender: AnyObject) {
        let floatSlideValue = (self.themeVolumeSlider.value * 100) / 1
        self.themeVolumeLabel.text = "Theme Volume \(floatSlideValue.cleanValue)%"
    }

    func doneAction () {


        let trackAmbient: AmbienceTrack = AmbienceTrack(type: AudioTrackType.Ambient, fileName:"\(self.ambientSegmentedControl.titleForSegmentAtIndex(ambientSegmentedControl.selectedSegmentIndex)!).mp3", startMinute:NSTimeInterval(1 * 60), length:round(self.ambienceTimeSlider.value), startVolume:0.01, finishVolume:self.ambienceVolumeSlider.value, numberOfLoops:-1, fadeInDuration: self.ambienceFadeInSlider.value * 60)

        let trackTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Ambient, fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!).mp3", startMinute:NSTimeInterval(1 * 60), length:0, startVolume:0.01, finishVolume:self.themeVolumeSlider.value, numberOfLoops:0, fadeInDuration: self.crossfadeSlider.value)


        let trackLoopTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Theme, fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!)Loop.mp3", startMinute:0, length:0, startVolume:self.themeVolumeSlider.value, finishVolume:self.themeVolumeSlider.value, numberOfLoops:-1, fadeInDuration: 0.0)

        self.delegate.configurationAlarm( Alarm(ambient: trackAmbient, theme: trackTheme, loopTheme: trackLoopTheme))

        self.dismissViewControllerAnimated(true, completion: nil)

    }


    func cancelAction() { {
            // TODO: Configure the alarm

            } ~> {
            // Main thread, work with the UI
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func ambientPlayStopAction(sender: UIButton) {
        let string = sender.titleLabel?.text!
        if string == "Play" {

            if self.audioPlayer != nil {
                self.audioPlayer?.stop()
            }

            sender.setTitle("Stop", forState: UIControlState.Normal)
            do {
                self.audioPlayer = try AudioPlayerManager(fileName:"\(self.ambientSegmentedControl.titleForSegmentAtIndex(ambientSegmentedControl.selectedSegmentIndex)!).mp3")
                self.audioPlayer?.numberOfLoops = -1 // Will loop indefinitely until stopped.
                self.audioPlayer?.play()
            } catch {
                print("oh-oh")
            }

        } else {
            sender.setTitle("Play", forState: UIControlState.Normal)
            self.audioPlayer?.stop()
        }

    }
    @IBAction func themePlayStopAction(sender: UIButton) {
        let string = sender.titleLabel?.text!
        if string == "Play" {

            if self.audioPlayer != nil {
                self.audioPlayer?.stop()
            }
            sender.setTitle("Stop", forState: UIControlState.Normal)
            do {
                self.audioPlayer = try AudioPlayerManager(fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!).mp3")
                self.audioPlayer?.numberOfLoops = -1 // Will loop indefinitely until stopped.
                self.audioPlayer?.play()
            } catch {
                print("oh-oh")
            }

        } else {
            sender.setTitle("Play", forState: UIControlState.Normal)
            self.audioPlayer?.stop()
        }

    }

}
