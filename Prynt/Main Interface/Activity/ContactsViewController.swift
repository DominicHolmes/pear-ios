//
//  ContactsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/20/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class ContactsViewController: PryntTableViewController {
    
    override var user: PryntUser! {
        didSet {
            contacts = user.contacts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    lazy var contacts: [Transaction]? = {
        return user.contacts()
    }()
}

// MARK: - Table View Delegate
extension ContactsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let contacts = contacts, contacts.count < indexPath.row else { return }
        performSegue(withIdentifier: "ViewTransactionSegue", sender: contacts[indexPath.row])
    }
}

// MARK: - Table View Data Source
extension ContactsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedTransactionCell")
        guard let contacts = contacts, indexPath.row < contacts.count else { return cell! }
        let contact = contacts[indexPath.row]
        (cell?.viewWithTag(100) as? UIImageView)?.image = UIImage(named: "Prynt")
        (cell?.viewWithTag(101) as? UILabel)?.text = relevantProfile(from: contact)?.usersName
        (cell?.viewWithTag(102) as? UILabel)?.text = relevantProfile(from: contact)?.handle
        return cell!
    }
    
}

extension ContactsViewController {
    func relevantProfile(from transaction: Transaction) -> PryntTransactionProfile? {
        var FIX_BEFORE_RELEASE__🛠🛠🛠: AnyObject
        guard let userIs = transaction.userIs else { return nil }
//        return userIs == .PRIMARY ? transaction.secondaryProfile : transaction.primaryProfile
        return userIs == .PRIMARY ? transaction.primaryProfile : transaction.secondaryProfile
    }
}
