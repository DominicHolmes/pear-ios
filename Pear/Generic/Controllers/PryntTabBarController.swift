//
//  PryntTabBarController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntTabBarController: UITabBarController {
    
    var user: PryntUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 2
    }
    
}
