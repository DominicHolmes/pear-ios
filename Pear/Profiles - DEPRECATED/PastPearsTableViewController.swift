//
//  PastPearsTableViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

struct PastPear {
    let transactionId: String
    let usersName: String
    let profileName: String
    let handle: String
}

class PastPearsTableViewController: PearTabTableViewController {
    
    var pears: [PastPear] = [PastPear]() {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        var tempPears = [PastPear]()
        for transaction in dict {
            let transDict = transaction.value
            if ((transDict.keys.contains("primaryHandle")) && (transDict.keys.contains("primaryName")) && (transDict.keys.contains("primaryUsersName"))) {
                let tempPear = PastPear(transactionId: transDict["transactionID"]!, 
                    usersName: transDict["primaryUsersName"]!, 
                    profileName: transDict["primaryName"]!, 
                    handle: transDict["primaryHandle"]!)
                tempPears.append(tempPear)
            } else if ((transDict.keys.contains("secondaryHandle")) && (transDict.keys.contains("secondaryName")) && (transDict.keys.contains("secondaryUsersName"))) {
                let tempPear = PastPear(transactionId: transDict["transactionID"]!, 
                    usersName: transDict["secondaryUsersName"]!, 
                    profileName: transDict["secondaryName"]!, 
                    handle: transDict["secondaryHandle"]!)
                tempPears.append(tempPear)
            }
        }
        pears = tempPears.sorted(by: { $0.usersName.first! < $1.usersName.first! })
    }
}

// MARK: - TableView Data Source
extension PastPearsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pears.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastPearCell")
        let pastPear = pears[indexPath.row]
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        profileNameLabel?.text = pastPear.usersName
        
        let profileHandleLabel = cell?.viewWithTag(101) as? UILabel
        profileHandleLabel?.text = "@" + pastPear.handle
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension PastPearsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
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
            let controller = segue.destination as! PearProfileViewController
            controller.popoverPresentationController!.delegate = self
            let profile = sender as? SocialProfile
            controller.socialProfile = profile
        }
    }
}
