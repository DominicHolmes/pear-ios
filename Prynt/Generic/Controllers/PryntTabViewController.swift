//
//  PryntTabViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntTabViewController: PryntViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
        }
    }
}

class PryntTabTableViewController: PryntTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
        }
    }
}
