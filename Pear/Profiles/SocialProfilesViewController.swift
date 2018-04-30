//
//  SocialProfilesViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 1/25/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class SocialProfilesViewController: PearViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView Data Source
extension SocialProfilesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUser!.profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        if indexPath.row < activeUser!.profiles.count {
            profileNameLabel?.text = activeUser!.profiles[indexPath.row].getName()
        } else {
            profileNameLabel?.text = ""
        }
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension SocialProfilesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "PearProfileSegue", sender: activeUser!.profiles[indexPath.row])
    }
    
    // Swipe to delete functionality
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "deleteProfileSegue", sender: nil)
    }
}

// MARK: - Delete Profile Popover
extension SocialProfilesViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

// MARK: - Segue Control
extension SocialProfilesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deleteProfileSegue" {
            let controller = segue.destination
            controller.popoverPresentationController!.delegate = self
        } else if segue.identifier == "PearProfileSegue" {
            let controller = segue.destination as! PearProfileViewController
            controller.popoverPresentationController!.delegate = self
            let profile = sender as? SocialProfile
            controller.socialProfile = profile
        }
    }
}
