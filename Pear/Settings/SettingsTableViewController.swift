//
//  SettingsViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - TableView Data Source
extension SettingsTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsOptionCell")
        
        let settingDescriptionLabel = cell?.viewWithTag(100) as? UILabel
        settingDescriptionLabel?.text = "Setting option"
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension SettingsTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
    }
}

// MARK: - Segue Control
extension SettingsTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
