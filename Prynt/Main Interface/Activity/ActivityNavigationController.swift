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
    
    var user: PryntUser! {
        didSet {
            self.fetchAllTransactions()
        }
    }
    
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
        
        // style the bar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UIColor.royale
            appearance.state.color = UIColor.unselectedGrey
            
            appearance.indicator.lineWeight = TabmanIndicator.LineWeight.thick
            appearance.indicator.color = UIColor.royale
            
            appearance.text.font = UIFont(name: "Montserrat-Bold", size: 14.0)
            //appearance.indicator.isProgressive = true
            
            appearance.layout.itemDistribution = TabmanBar.Appearance.Layout.ItemDistribution.fill
        })
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .last
    }
    
    private func fetchAllTransactions() {
        TransactionNetworkingManager.shared.fetchAllTransactions(for: user.id) { (success, transactions) in
            if success, let transactions = transactions {
                self.user.transactions = transactions
                self.updateViewControllers()
            } else {
                print("Could not fetch user transactions")
            }
        }
    }
    
    private func updateViewControllers() {
        for each in (viewControllers as! [PryntTableViewController]) {
            each.user = self.user
        }
    }
}
