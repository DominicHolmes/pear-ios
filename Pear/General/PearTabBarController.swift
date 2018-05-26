//
//  PearTabBarController.swift
//  Pear
//
//  Created by dominic on 5/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PearTabBarController: UITabBarController {
    
    var databaseRef: DatabaseReference!
    var activeUser: PearUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 2
    }
    
}
