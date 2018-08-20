//
//  PersonalViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/20/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

import UIKit
import Tabman
import Pageboy

class PersonalNavigationController: TabmanViewController, PageboyViewControllerDataSource {
    
    var user: PryntUser!
    
    lazy var viewControllers : [UIViewController] = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let profilesVC = storyboard.instantiateViewController(withIdentifier: "ProfilesViewController") as! ProfilesViewController
        let accountsVC = storyboard.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
        
        profilesVC.user = user
        accountsVC.user = user
        
        return [accountsVC, profilesVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // configure the bar
        self.bar.items = [Item(title: "Contacts"),
                          Item(title: "Requests")]
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
