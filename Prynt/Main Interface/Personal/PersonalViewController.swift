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
    
    var user: PryntUser! {
        didSet {
            self.fetchAllAccounts()
            self.fetchAllProfiles()
        }
    }
    
    lazy var viewControllers : [UIViewController] = {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let profilesVC = storyboard.instantiateViewController(withIdentifier: "ProfilesViewController") as! ProfilesViewController
        let accountsVC = storyboard.instantiateViewController(withIdentifier: "AccountsViewController") as! AccountsViewController
        
        profilesVC.user = user
        accountsVC.user = user
        
        return [profilesVC, accountsVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // configure the bar
        self.bar.items = [Item(title: "Clusters"),
                          Item(title: "Accounts")]
        
        // style the bar
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.state.selectedColor = UIColor.royale
            appearance.state.color = UIColor.unselectedGrey
            
            appearance.indicator.lineWeight = TabmanIndicator.LineWeight.thick
            appearance.indicator.color = UIColor.royale
            
            appearance.text.font = UIFont(name: "Montserrat-Bold", size: 14.0)
            
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
        return .first
    }
}

// MARK: - Networking
extension PersonalNavigationController {
    
    fileprivate func fetchAllAccounts() {
        AccountNetworkingManager.shared.fetchAllAccounts(for: user.id) { (success, accounts) in
            if success, let accounts = accounts {
                self.user.accounts = accounts
                if let vc = self.viewControllers[0] as? AccountsViewController {
                    vc.user = self.user
                }
            } else {
                print("Could not fetch accounts. Check internet.")
            }
        }
    }
    
    fileprivate func fetchAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: user.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.user.profiles = profiles
                if let vc = self.viewControllers[0] as? ProfilesViewController {
                    vc.user = self.user
                }
            } else {
                print("Could not fetch profiles. Check internet.")
            }
        }
    }
}
