//
//  ChooseAccountsViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/13/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class ChooseAccountsViewController: PryntViewController {
    
    var accounts: [Account]?
    fileprivate var checkedAccounts = [AccountId]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAccounts()
        fetchAllAccounts()
    }
    
    internal func fetchAllAccounts() {
        AccountNetworkingManager.shared.fetchAllAccounts(for: user.id) { (success, accounts) in
            if success, let accounts = accounts {
                self.user.accounts = accounts
                self.updateAccounts()
            }
        }
    }
    
    internal func updateAccounts() {
        accounts = user.accounts
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Data Source
extension ChooseAccountsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as! NetworkCollectionCell
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        
        guard let accounts = accounts, indexPath.row < accounts.count else { return cell }
        
        let account = accounts[indexPath.row]
        cell.socialServiceType = account.service
        cell.accountToDisplay = nil
        cell.accountToEdit = nil
        cellImageView?.image = UIImage(named: account.service.photoName)
        return cell
    }
}

// MARK: - CollectionView Delegate
extension ChooseAccountsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let accounts = accounts, indexPath.row < accounts.count else { return }
        let account = accounts[indexPath.row]
        var isChecked: Bool
        
        if let index = checkedAccounts.index(where: { $0 == account.id }) {
            checkedAccounts.remove(at: index)
            isChecked = false
        } else {
            checkedAccounts.append(account.id)
            isChecked = true
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? NetworkCollectionCell {
            cell.isChecked = isChecked
        }
    }
}
