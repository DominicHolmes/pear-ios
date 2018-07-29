//
//  WelcomeViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 1/24/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TEST CODE - - -
    
    @IBAction func create() {
        let userInfo = UserInfo(id: "test-Id", username: "hdom", nameFirst: "Dominic", nameLast: "Holmes")
        UserNetworkingManager.shared.createUser(from: userInfo) { (success, user) in
            dump(user)
        }
    }
    
    @IBAction func getUser() {
        UserNetworkingManager.shared.fetchUser(for: "test-Id") { (success, user) in
            print(success)
            dump(user)
        }
        UserNetworkingManager.shared.fetchUser(for: "test-Id2") { (success, user) in
            print(success)
            dump(user)
        }
    }
    
    @IBAction func update() {
        let userInfo = UserInfo(id: "test-Id2", username: "hdom2", nameFirst: "Dominic2", nameLast: "Holmes2")
        UserNetworkingManager.shared.updateUser(from: userInfo) { (success, user) in
            dump(user)
        }
    }
    
    @IBAction func delete() {
        UserNetworkingManager.shared.deleteUser(with: "test-Id") { (success) in
            dump(success)
        }
    }
    
    // END - - -
    
    
}
