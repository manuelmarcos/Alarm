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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneAction"), animated: false)
    }
    
    func doneAction() {
        // TODO: Set configuration and close view.
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
