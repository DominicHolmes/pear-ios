//
//  TransactionViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/19/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class TransactionViewController: PryntViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var reciprocateTransactionButton: UIButton!

    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var usersHandleLabel: UILabel!
    
    var fullTransaction: Transaction? {
        didSet {
            self.transaction = fullTransaction?.transaction
            self.primary = fullTransaction?.primaryProfile
            self.secondary = fullTransaction?.secondaryProfile
            self.userIs = fullTransaction?.userIs
        }
    }
    
    var context: TransactionContext? {
        didSet {
            if let userIs = self.userIs, let context = self.context {
                if userIs == .SECONDARY && context == .SECONDARY {
                    self.collectionView.isHidden = true
                    self.reciprocateTransactionButton.isHidden = false
                    self.reciprocateTransactionButton.isEnabled = true
                } else {
                    self.collectionView.isHidden = false
                    self.reciprocateTransactionButton.isEnabled = false
                    self.reciprocateTransactionButton.isHidden = true
                }
            }
        }
    }
    
    private var transaction: TransactionDetails?
    private var primary: PryntTransactionProfile?
    private var secondary: PryntTransactionProfile?
    private var userIs: TransactionContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let primary = primary {
            usersNameLabel.text = primary.usersName
            usersHandleLabel.text = "@" + primary.handle
        }
    }
    
    @IBAction func userDidSelectDone() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Collection View Data Source
extension TransactionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return primary?.accounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as? NetworkCollectionCell
        
        guard let accounts = primary?.accounts, indexPath.row < accounts.count else { return cell! }
        
        let cellImageView = cell!.viewWithTag(100) as? UIImageView
        let account = accounts[indexPath.row]
        cellImageView?.image = UIImage(named: account.service.photoName)
        
        return cell!
    }
}

// MARK: - Collection View Delegate
extension TransactionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let accounts = primary?.accounts, indexPath.row < accounts.count else { return }
        let account = accounts[indexPath.row]
        
        let username = account.handle
        
        let appURLString = account.service.appURL + username
        let webURLString = account.service.webURL + username
        
        let appURL = NSURL(string: appURLString)!
        let webURL = NSURL(string: webURLString)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
}
