//
//  ContactsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/20/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class ContactsViewController: PryntTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ContactsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return user.getContacts().count
    }
    
    
}
