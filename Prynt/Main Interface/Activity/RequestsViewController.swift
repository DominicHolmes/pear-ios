//
//  RequestsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/20/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class RequestsViewController: PryntTableViewController {
    
    override var user: PryntUser! {
        didSet {
            requests = user.requests()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    lazy var requests: [Transaction]? = {
        return user.requests()
    }()
}

// MARK: - Table View Delegate
extension RequestsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let requests = requests, indexPath.row < requests.count else { return }
        performSegue(withIdentifier: "ViewTransactionSegue", sender: requests[indexPath.row])
    }
}

// MARK: - Table View Data Source
extension RequestsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTransactionCell")
        guard let requests = requests, indexPath.row < requests.count else { return cell! }
        let request = requests[indexPath.row]
        (cell?.viewWithTag(100) as? UIImageView)?.image = UIImage(named: "Prynt")
        (cell?.viewWithTag(101) as? UILabel)?.text = relevantProfile(from: request)?.usersName
        (cell?.viewWithTag(102) as? UILabel)?.text = relevantProfile(from: request)?.handle
        return cell!
    }
    
}

extension RequestsViewController {
    func relevantProfile(from transaction: Transaction) -> PryntTransactionProfile? {
        var FIX_BEFORE_RELEASE__🛠🛠🛠: AnyObject
        guard let userIs = transaction.userIs else { return nil }
        //        return userIs == .PRIMARY ? transaction.secondaryProfile : transaction.primaryProfile
        return userIs == .PRIMARY ? transaction.primaryProfile : transaction.secondaryProfile
    }
}

// MARK: - Segue Control
extension RequestsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewTransactionSegue", let sender = sender as? Transaction {
            let nav = segue.destination as! UINavigationController
            let controller = nav.topViewController as! ExternalNavigationController
            controller.user = self.user
            controller.fullTransaction = sender
        }
    }
}
