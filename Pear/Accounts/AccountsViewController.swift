//
//  AccountsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/10/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class AccountsViewController: PryntViewController {
    
    private var allServices = SocialServiceType.allValues
    private var enabledAccounts: [Account]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func xButtonTapped() { dismiss(animated: true, completion: nil) }
    
    internal func create(_ account: Account) {
        
    }
    
    internal func update(_ account: Account) {
        
    }
    
    internal func delete(_ account: Account) {
        
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
        
        if let enabledAccounts = enabledAccounts, indexPath.section == 0 {
            let account = enabledAccounts[indexPath.row]
            cell.socialServiceType = account.service
            cell.accountToEdit = account
            cellImageView?.image = UIImage(named: account.service.photoName)
        } else {
            let serviceType = allServices[indexPath.row]
            cell.socialServiceType = serviceType
            cellImageView?.image = UIImage(named: serviceType.photoName)
        }
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension AccountsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*let cell = collectionView.cellForItem(at: indexPath) as? NetworkCollectionCell
        
        if cell != nil && cell!.isChecked {
            cell!.isChecked = false
            if let service = cell!.socialService {
                //enabledServices = enabledServices.filter { $0.socialService != service.socialService &&
                //$0.handle != service.handle}
            }
        } else if cell != nil && !cell!.isChecked {
            self.lastTappedCell = cell
            performSegue(withIdentifier: "addNetworkSegue", sender: cell)
        }*/
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
    
    func viewAccountViewControllerDidUpdate(_ controller: ViewAccountViewController, account: Account) {
        controller.dismiss(animated: true, completion: nil)
        update(account)
    }
    
    func viewAccountViewControllerDidCreate(_ controller: ViewAccountViewController, account: Account) {
        controller.dismiss(animated: true, completion: nil)
        create(account)
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
        if segue.identifier == "addNetworkSegue" {
            let controller = segue.destination as! ViewAccountViewController
            controller.popoverPresentationController!.delegate = self
            controller.delegate = self
            let sender = sender as! NetworkCollectionCell
            controller.socialServiceType = sender.socialServiceType
            //controller.socialService = sender.socialService
        } else if segue.identifier == "ProfileConstructionCompletedSegue" {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PryntTabBarController
            tabBarController.user = self.user
        }
    }
}
