//
//  WelcomeViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 1/24/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    @IBAction func clearBlockchain() {
        UserNetworkingManager.shared.clearBlockchain { (success) in
            print(success)
        }
    }
}
