//
//  NotificationsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 1/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
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
extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell")
        
        let notificationDescriptionLabel = cell?.viewWithTag(100) as? UILabel
        notificationDescriptionLabel?.text = "New app feature from your friends at Prynt!"
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
    }
}

// MARK: - Segue Control
extension NotificationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
