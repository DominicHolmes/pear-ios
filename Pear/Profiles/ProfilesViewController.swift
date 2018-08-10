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
    @IBOutlet weak var tableView: UITableView!
    
}

// MARK: - TableView Data Source
extension ProfilesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profiles = profiles, profiles.count > indexPath.row else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PryntProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        profileNameLabel?.text = profiles[indexPath.row].profileName
        
        let handleLabel = cell?.viewWithTag(101) as? UILabel
        handleLabel?.text = profiles[indexPath.row].handle
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension ProfilesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let profiles = profiles, profiles.count > indexPath.row else { return }
        
        performSegue(withIdentifier: "ViewPryntProfileSegue", sender: profiles[indexPath.row])
    }
    
    // Swipe to delete UI functionality
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard let profiles = profiles, profiles.count > indexPath.row else { return }
        performSegue(withIdentifier: "ConfirmDeletePryntProfileSegue", sender: profiles[indexPath.row])
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
