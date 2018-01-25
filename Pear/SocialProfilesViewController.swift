//
//  SocialProfilesViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 1/25/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class SocialProfilesViewController: UIViewController {
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        profileNameLabel?.text = "Social"
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension SocialProfilesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
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
        }
    }
}
