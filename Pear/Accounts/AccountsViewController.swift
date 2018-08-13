//
//  AccountsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/10/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class AccountsViewController: PryntTabViewController {
    
    private var allServices = SocialServiceType.allValues
    private var enabledAccounts: [Account]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
        }
        readAllAccounts()
    }
    
    func readAllAccounts() {
        AccountNetworkingManager.shared.fetchAllAccounts(for: user.id) { (success, accounts) in
            if success, let accounts = accounts {
                self.user.accounts = accounts
                self.updateEnabledAccounts()
            } else {
                self.displayAlert("Error", "Could not fetch accounts. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    internal func create(_ accountCreate: AccountCreate) {
        AccountNetworkingManager.shared.createAccount(from: accountCreate) { (success, account) in
            if success, let account = account {
                self.user.add(account)
                self.updateEnabledAccounts()
            } else {
                self.displayAlert("Error", "Could not create account. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    internal func update(_ account: AccountUpdate) {
        AccountNetworkingManager.shared.updateAccount(from: account) { (success, account) in
            if success, let account = account {
                self.user.add(account)
                self.updateEnabledAccounts()
            } else {
                self.displayAlert("Error", "Could not update account. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    internal func delete(_ account: Account) {
        AccountNetworkingManager.shared.deleteAccount(for: user.id, with: account.id) { (success) in
            if success {
                self.user.remove(account: account.id)
                self.updateEnabledAccounts()
            } else {
                self.displayAlert("Error", "Could not delete account. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    internal func updateEnabledAccounts() {
        enabledAccounts = user.accounts
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Data Source
extension AccountsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let _ = enabledAccounts, enabledAccounts!.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = enabledAccounts, enabledAccounts!.count > 0, section == 0 {
            return enabledAccounts!.count
        } else {
            return allServices.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as! NetworkCollectionCell
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        
        if let enabledAccounts = enabledAccounts, enabledAccounts.count > 0, indexPath.section == 0 {
            let account = enabledAccounts[indexPath.row]
            cell.socialServiceType = account.service
            cell.accountToDisplay = nil
            cell.accountToEdit = account
            cellImageView?.image = UIImage(named: account.service.photoName)
        } else {
            let serviceType = allServices[indexPath.row]
            cell.socialServiceType = serviceType
            cell.accountToDisplay = nil
            cell.accountToEdit = nil
            cellImageView?.image = UIImage(named: serviceType.photoName)
        }
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension AccountsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? NetworkCollectionCell
        
        if let accountToEdit = cell?.accountToEdit {
            performSegue(withIdentifier: "EditAccountSegue", sender: accountToEdit)
        } else if let accountToDisplay = cell?.accountToDisplay {
            performSegue(withIdentifier: "ViewAccountSegue", sender: accountToDisplay)
        } else if let cell = cell, let service = cell.socialServiceType {
            performSegue(withIdentifier: "CreateAccountSegue", sender: service)
        }
    }
}

// MARK: - Add New Network Popover
extension AccountsViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

extension AccountsViewController: ViewAccountViewControllerDelegate {
    
    func viewAccountViewControllerDidCancel(_ controller: ViewAccountViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func viewAccountViewControllerDidUpdate(_ controller: ViewAccountViewController, accountUpdate: AccountUpdate) {
        controller.dismiss(animated: true, completion: nil)
        update(accountUpdate)
    }
    
    func viewAccountViewControllerDidCreate(_ controller: ViewAccountViewController, accountCreate: AccountCreate) {
        controller.dismiss(animated: true, completion: nil)
        create(accountCreate)
    }
    
    func viewAccountViewControllerDidDelete(_ controller: ViewAccountViewController, account: Account) {
        controller.dismiss(animated: true, completion: nil)
        delete(account)
    }
    
    /*func addNewServiceViewControllerDidSave(_ controller: ViewAccountViewController, withService service: SocialService?) {
        controller.dismiss(animated: true, completion: nil)
        if let _ = service {
            //enabledServices.append(service!)
            lastTappedCell?.socialService = service
        }
        lastTappedCell?.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }*/
    
    
}

// MARK: - Segue Control
extension AccountsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ViewAccountViewController else { return }
        
        controller.popoverPresentationController!.delegate = self
        controller.delegate = self
        
        if segue.identifier == "CreateAccountSegue", let service = sender as? SocialServiceType {
            controller.service = service
            controller.userId = user.id
        } else if segue.identifier == "EditAccountSegue", let account = sender as? Account {
            controller.service = account.service
            controller.accountToEdit = account
            dump(account)
        } else if segue.identifier == "ViewAccountSegue", let account = sender as? Account {
            controller.service = account.service
            controller.accountToDisplay = account
        }
    }
}
