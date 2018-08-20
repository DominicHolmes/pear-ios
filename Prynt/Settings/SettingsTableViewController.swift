//
//  SettingsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    private let settingsOptions = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView Data Source
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsOptionCell")
        
        let settingDescriptionLabel = cell?.viewWithTag(100) as? UILabel
        settingDescriptionLabel?.text = settingsOptions[indexPath.row]
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
        
        if indexPath.row == 0 {
            logOut()
        }
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
        }
        
        self.performSegue(withIdentifier: "logOutSegue", sender: nil)
    }
}

// MARK: - Segue Control
extension SettingsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
