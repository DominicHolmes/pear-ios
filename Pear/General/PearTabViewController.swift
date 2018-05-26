//
//  PearTabViewController.swift
//  Pear
//
//  Created by dominic on 5/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PearTabViewController: PearViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pearTBC = self.tabBarController as? PearTabBarController {
            self.activeUser = pearTBC.activeUser
            self.databaseRef = pearTBC.databaseRef
        }
    }
}

class PearTabTableViewController: PearTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pearTBC = self.tabBarController as? PearTabBarController {
            self.activeUser = pearTBC.activeUser
            self.databaseRef = pearTBC.databaseRef
        }
    }
}
