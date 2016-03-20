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
    @IBOutlet var totalTimeTextField: UITextField!
    @IBOutlet var ambientSegmentedControl: UISegmentedControl!
    @IBOutlet var ambientStartingMinuteTextField: UITextField!
    @IBOutlet var ambientStartingVolumeTextField: UITextField!
    @IBOutlet var ambientFinishingVolumeTextField: UITextField!
    
    @IBOutlet var themeSegmentedControl: UISegmentedControl!
    @IBOutlet var themeStartingMinuteTextField: UITextField!
    @IBOutlet var themeStartingVolumeTextField: UITextField!
    @IBOutlet var themeFinishingVolumeTextField: UITextField!
    
    @IBOutlet var voiceSegmentedControl: UISegmentedControl!
    @IBOutlet var voiceStartingMinuteTextField: UITextField!
    @IBOutlet var voiceStartingVolumeTextField: UITextField!
    @IBOutlet var voiceFinishingVolumeTextField: UITextField!
    
    var audioPlayer: AudioPlayerManager?
    
    var delegate: ConfigurationAlarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneAction"), animated: false)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelAction"), animated: false)
        
        self.ambientSegmentedControl.setTitle("ambient1", forSegmentAtIndex: 0)
        self.ambientSegmentedControl.setTitle("ambient2", forSegmentAtIndex: 1)
        self.ambientSegmentedControl.setTitle("ambient3", forSegmentAtIndex: 2)
    
        self.themeSegmentedControl.setTitle("theme1", forSegmentAtIndex: 0)
        self.themeSegmentedControl.setTitle("theme2", forSegmentAtIndex: 1)
        self.themeSegmentedControl.setTitle("theme3", forSegmentAtIndex: 2)
    
        self.voiceSegmentedControl.setTitle("voice1", forSegmentAtIndex: 0)
        self.voiceSegmentedControl.setTitle("voice2", forSegmentAtIndex: 1)
        self.voiceSegmentedControl.setTitle("voice3", forSegmentAtIndex: 2)
    }
    
    func doneAction () {        
        if self.isValidAmbient() && self.isValidTheme() && self.isValidVoice(),
        let totalDuration = Int(totalTimeTextField.text!) {
            
            let trackAmbient: AudioTrack = AudioTrack(type: AudioTrackType.Ambient, fileName:"\(self.ambientSegmentedControl.titleForSegmentAtIndex(ambientSegmentedControl.selectedSegmentIndex)!).mp3", startMinute: NSTimeInterval(Float(ambientStartingMinuteTextField.text!)! * 60), startVolume: Float(ambientStartingVolumeTextField.text!)!, finishVolume: Float(ambientFinishingVolumeTextField.text!)!)
            
            
            let trackTheme: AudioTrack = AudioTrack(type: AudioTrackType.Theme, fileName:"\(self.themeSegmentedControl.titleForSegmentAtIndex(themeSegmentedControl.selectedSegmentIndex)!).mp3", startMinute: NSTimeInterval(Float(themeStartingMinuteTextField.text!)! * 60), startVolume: Float(themeStartingVolumeTextField.text!)!, finishVolume: Float(themeFinishingVolumeTextField.text!)!)
            
            let trackVoice: AudioTrack = AudioTrack(type: AudioTrackType.Voice, fileName:"\(self.voiceSegmentedControl.titleForSegmentAtIndex(voiceSegmentedControl.selectedSegmentIndex)!).mp3", startMinute: NSTimeInterval(Float(voiceStartingMinuteTextField.text!)! * 60), startVolume: Float(voiceStartingVolumeTextField.text!)!, finishVolume: Float(voiceFinishingVolumeTextField.text!)!)
            
            self.delegate.configurationAlarm( Alarm(ambient: trackAmbient, theme: trackTheme, voice: trackVoice, totalTime: NSTimeInterval(totalDuration * 60)))
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            AlertsUtils.showAlertWithErrorMessage("You have introduced incorrect data. Please review it again.")
        }
    }
    
    func isValidAmbient() -> Bool {
    
        if (!(ambientStartingMinuteTextField.text!.isEmpty) ||
            !(ambientStartingVolumeTextField.text!.isEmpty)  ||
            !(ambientFinishingVolumeTextField.text!.isEmpty)) {
                
                if let minutes = Int(ambientStartingMinuteTextField.text!),
                    let ambientStartVolume = Double(ambientStartingVolumeTextField.text!),
                    let ambientFinishVolume = Double(ambientFinishingVolumeTextField.text!)
                {
                    if 0.01 ... 1.00 ~= ambientStartVolume &&
                       0.01 ... 1.00 ~= ambientFinishVolume
                    {
                        
                        return true
                    }
                    
                }
        }
        return false
    }
    func isValidTheme() -> Bool {
        
        if (!(themeStartingMinuteTextField.text!.isEmpty) ||
            !(themeStartingVolumeTextField.text!.isEmpty)  ||
            !(themeFinishingVolumeTextField.text!.isEmpty)) {
                
                if let minutes = Int(themeStartingMinuteTextField.text!),
                    let ambientStartVolume = Double(themeStartingVolumeTextField.text!),
                    let ambientFinishVolume = Double(themeFinishingVolumeTextField.text!)
                {
                    if 0.01 ... 1.00 ~= ambientStartVolume &&
                        0.01 ... 1.00 ~= ambientFinishVolume
                    {
                        
                        return true
                    }
                    
                }
        }
        return false
    }
    func isValidVoice() -> Bool {
        
        if (!(voiceStartingMinuteTextField.text!.isEmpty) ||
            !(voiceStartingVolumeTextField.text!.isEmpty)  ||
            !(voiceFinishingVolumeTextField.text!.isEmpty)) {
                
                if let minutes = Int(voiceStartingMinuteTextField.text!),
                    let ambientStartVolume = Double(voiceStartingVolumeTextField.text!),
                    let ambientFinishVolume = Double(voiceFinishingVolumeTextField.text!)
                {
                    if 0.01 ... 1.00 ~= ambientStartVolume &&
                        0.01 ... 1.00 ~= ambientFinishVolume
                    {
                        
                        return true
                    }
                    
                }
        }
        return false
    }
    
    func cancelAction() {
        {
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
    @IBAction func voicePlayStopAction(sender: UIButton) {
        let string = sender.titleLabel?.text!
        if string == "Play" {
            if self.audioPlayer != nil {
                self.audioPlayer?.stop()
            }
            sender.setTitle("Stop", forState: UIControlState.Normal)
            do {
                self.audioPlayer = try AudioPlayerManager(fileName:"\(self.voiceSegmentedControl.titleForSegmentAtIndex(voiceSegmentedControl.selectedSegmentIndex)!).mp3")
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
