//
//  ProfilesViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class ProfilesViewController: PryntTabViewController {
    
    override var user: PryntUser! {
        didSet {
            self.profiles = user.profiles
        }
    }
    var profiles: [PryntProfile]?
    
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var usersHandleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usersNameLabel.text = user.firstName + " " + user.lastName
        usersHandleLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profiles = user.profiles
        collectionView.reloadData()
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
extension ProfilesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + (profiles?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == (profiles?.count ?? 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateClusterCell", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCell", for: indexPath)
            guard let profiles = profiles, indexPath.row < profiles.count else { return cell }
            let profile = profiles[indexPath.row]
            let accounts = profile.accounts ?? [Account]()
            
            for i in 0 ..< accounts.count {
                guard i < 3 else { return cell }
                
                let imageView = cell.viewWithTag(201 + i) as? UIImageView
                imageView?.image = UIImage(named: accounts[i].service.photoName)
            }
            
            let profileNameLabel = cell.viewWithTag(100) as? UILabel
            profileNameLabel?.text = profile.profileName

            return cell
        }
    }
}

// MARK: - CollectionView Delegate
extension ProfilesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == (profiles?.count ?? 0) {
            performSegue(withIdentifier: "CreateClusterSegue", sender: nil)
        } else {
            guard let profiles = profiles, indexPath.row < profiles.count else { return }
            let profile = profiles[indexPath.row]
            performSegue(withIdentifier: "EditClusterSegue", sender: profile)
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
        if segue.identifier == "CreateClusterSegue" {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! CreateProfileViewController
            controller.user = self.user
        } else if segue.identifier == "EditClusterSegue", let sender = sender as? PryntProfile {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! EditProfileViewController
            controller.user = self.user
            controller.profileToEdit = sender
        }
    }
}
