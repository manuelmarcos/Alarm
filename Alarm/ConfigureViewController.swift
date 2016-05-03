//
//  ConfigureViewController.swift
//  Alarm
//
//  Created by Manuel Marcos Regalado on 12/03/2016.
//  Copyright © 2016 Manuel Marcos Regalado. All rights reserved.
//

import Foundation
import UIKit

class ConfigureViewController: UIViewController {
    @IBOutlet var ambientSegmentedControl: UISegmentedControl!
    @IBOutlet var themeSegmentedControl: UISegmentedControl!

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

    func doneAction () {

            let trackAmbient: AmbienceTrack = AmbienceTrack(type: AudioTrackType.Ambient, fileName:"\(self.ambientSegmentedControl.titleForSegmentAtIndex(ambientSegmentedControl.selectedSegmentIndex)!).mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.01, finishVolume:0.9, numberOfLoops:-1)
            let trackTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Ambient, fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!).mp3", startMinute:NSTimeInterval(1 * 60), startVolume:0.01, finishVolume:0.8, numberOfLoops:0)


            let trackLoopTheme: ThemeTrack = ThemeTrack(type: AudioTrackType.Theme, fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!)Loop.mp3", startMinute:0, startVolume:0.8, finishVolume:0.8, numberOfLoops:-1)
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
