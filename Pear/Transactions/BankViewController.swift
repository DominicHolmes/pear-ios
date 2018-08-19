//
//  BankViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/19/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class BankViewController: PryntTabViewController {
    
    var profiles: [PryntProfile]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pryntTBC = self.tabBarController as? PryntTabBarController {
            self.user = pryntTBC.user
            profiles = user.profiles
            fetchAllProfiles()
        }
    }
    
    func fetchAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: user.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.user.profiles = profiles
                self.updateShownProfiles()
            } else {
                self.displayAlert("Error", "Could not fetch profiles. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    private func updateShownProfiles() {
        profiles = user.profiles
        collectionView.reloadData()
    }
    
}

// MARK: - CollectionView Data Source
extension BankViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (profiles?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCell", for: indexPath)
        guard let profiles = profiles, indexPath.row < profiles.count else { return cell }
        let profile = profiles[indexPath.row]
        let accounts = profile.accounts ?? [Account]()
        
        for i in 0 ..< accounts.count {
            guard i < 3 else { return cell }
            
            let imageView = cell.viewWithTag(200 + i) as? UIImageView
            imageView?.image = UIImage(named: accounts[i].service.photoName)
        }
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension BankViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let profiles = profiles, indexPath.row < profiles.count else { return }
        let profile = profiles[indexPath.row]
        performSegue(withIdentifier: "EditClusterSegue", sender: profile)
    }
}

// MARK: - Delete Profile Popover
extension BankViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        // TODO: Implement Profile Deletion
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
}

// MARK: - Segue Control
extension BankViewController {
    
    // TODO: Hook up segue stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CreateClusterSegue" {
//            let nav = segue.destination as! UINavigationController
//            let controller = nav.topViewController as! CreateProfileViewController
//            controller.user = self.user
//        } else if segue.identifier == "EditClusterSegue", let sender = sender as? PryntProfile {
//            let nav = segue.destination as! UINavigationController
//            let controller = nav.topViewController as! EditProfileViewController
//            controller.user = self.user
//            controller.profileToEdit = sender
//        }
    }
}
