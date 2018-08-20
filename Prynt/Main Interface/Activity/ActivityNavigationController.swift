//
//  PryntSheetViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/20/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class ActivityNavigationController: TabmanViewController, PageboyViewControllerDataSource {
    
    var user: PryntUser!
    
    lazy var viewControllers : [UIViewController] = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let requestsVC = storyboard.instantiateViewController(withIdentifier: "RequestsViewController") as! RequestsViewController
        let contactsVC = storyboard.instantiateViewController(withIdentifier: "ContactsViewController") as! ContactsViewController
        
        requestsVC.user = user
        contactsVC.user = user
        
        return [contactsVC, requestsVC]
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
