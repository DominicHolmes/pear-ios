//
//  ProfilesViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class ProfilesViewController: PryntTabViewController {
    
    var profiles: [PryntProfile]?
    @IBOutlet weak var collectionView: UICollectionView!
    
}

// MARK: - CollectionView Data Source
extension ProfilesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (profiles?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == (profiles?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateClusterCell", for: indexPath) as! UICollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCell", for: indexPath) as! ProfileCell
            guard let profiles = profiles, indexPath.row < profiles.count else { return cell }
            
            let profileNameLabel = cell.viewWithTag(100) as? UILabel
            profileNameLabel?.text = profiles[indexPath.row].profileName
            
            return cell
        }
    }
}

// MARK: - CollectionView Delegate
extension ProfilesViewController: UICollectionViewDelegate {
    
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

// MARK: - Delete Profile Popover
extension ProfilesViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        // TODO: Implement Profile Deletion
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
}

// MARK: - Segue Control
extension ProfilesViewController {
    
    // TODO: Hook up segue stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmDeletePryntProfileSegue" {
            let controller = segue.destination
            //controller.popoverPresentationController!.delegate = self
        } else if segue.identifier == "ViewPryntProfileSegue" {
            let controller = segue.destination as! PearProfileViewController
            /*controller.popoverPresentationController!.delegate = self
            let profile = sender as? SocialProfile
            controller.socialProfile = profile*/
        } else if segue.identifier == "CreateNewPryntProfileSegue" {
            let controller = segue.destination as! CreatePryntProfileViewController
            controller.user = self.user
        }
    }
}
