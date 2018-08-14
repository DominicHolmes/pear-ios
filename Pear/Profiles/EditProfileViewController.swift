//
//  EditProfileViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/13/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class EditProfileViewController: PryntViewController {
    
    @IBAction func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    var profileToEdit: PryntProfile?
    @IBOutlet weak var collectionView: UICollectionView!
}

// MARK: - CollectionView Data Source
extension EditProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (profileToEdit?.accounts?.count ?? 0) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as! NetworkCollectionCell
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        
        guard let accounts = profileToEdit?.accounts, accounts.count != indexPath.row else {
            cellImageView?.image = UIImage(named: "pear-logo")
            cell.socialServiceType = nil
            cell.accountToDisplay = nil
            cell.accountToEdit = nil
            return cell
        }
        
        let account = accounts[indexPath.row]
        cell.socialServiceType = account.service
        cell.accountToDisplay = nil
        cell.accountToEdit = account
        cellImageView?.image = UIImage(named: account.service.photoName)
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension EditProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let accounts = profileToEdit?.accounts, accounts.count != indexPath.row else {
            performSegue(withIdentifier: "AddNewAccountsSegue", sender: nil)
            return
        }
        
        let account = accounts[indexPath.row]
        let service = account.service
        let username = account.handle
        
        let appURLString = service.appURL + username
        let webURLString = service.webURL + username
        
        let appURL = NSURL(string: appURLString)!
        let webURL = NSURL(string: webURLString)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
}

// MARK: - Segue Control
extension EditProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewAccountsSegue" {
            let controller = segue.destination as! ChooseAccountsViewController
            controller.user = self.user
            controller.accounts = self.user.accounts
        }
    }
}
