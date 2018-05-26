//
//  PastPearsTableViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PastPearsTableViewController: PearTabTableViewController {
    
    var pears: [PearTransaction]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginFetchingPastPears()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Fetch Pears
extension PastPearsTableViewController {
    func beginFetchingPastPears() {
        let ref = databaseRef.child("usersTransactions").child(activeUser!.id)
        ref.observe(.value) { (snapshot) in
            if let _ = snapshot.value, let dict = snapshot.value as? Dictionary<String,Dictionary<String,String>> {
                self.getTransactions(from: dict)
            }
        }
    }
    
    func getTransactions(from dict: Dictionary<String, Dictionary<String, String>>) {
        dump(dict)
    }
}

// MARK: - TableView Data Source
extension PastPearsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastPearCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        profileNameLabel?.text = "Gustavo Ortega"
        
        let profileHandleLabel = cell?.viewWithTag(101) as? UILabel
        profileHandleLabel?.text = "@gustavo-ortega"
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension PastPearsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
    }
    
    // Swipe to delete functionality
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewPastPearSegue", sender: nil)
    }
}

// MARK: - Delete Profile Popover
extension PastPearsTableViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

// MARK: - Segue Control
extension PastPearsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewPastPearSegue" {
            let controller = segue.destination
            controller.popoverPresentationController!.delegate = self
        }
    }
}
