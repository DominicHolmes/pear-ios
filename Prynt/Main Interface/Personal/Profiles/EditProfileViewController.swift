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
    
    internal func updateProfile(with profileUpdate: PryntProfileUpdate) {
        ProfileNetworkingManager.shared.updateProfile(from: profileUpdate) { (success, profile) in
            if success, let profile = profile {
                self.user.add(profile)
                self.profileToEdit = profile
                self.collectionView.reloadData()
                print("Update completed successfully")
            } else {
                self.displayAlert("Error", "Couldn't update cluster. Please try again later.", nil)
            }
        }
    }
    
    internal func delete(_ profile: PryntProfile) {
        ProfileNetworkingManager.shared.deleteProfile(for: user.id, with: profile.id) { (success) in
            if success {
                self.user.remove(profile: profile.id)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.displayAlert("Error", "Could not delete account. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

// MARK: - ChooseAccountViewController Delegate
extension EditProfileViewController: ChooseAccountsViewControllerDelegate {
    
    func chooseAccountsViewControllerDidUpdate(_ controller: ChooseAccountsViewController, checkedAccounts: [AccountId]) {
        dismiss(animated: true, completion: nil)
        if let p = profileToEdit {
            let profileUpdate = PryntProfileUpdate(id: p.id, userId: user.id, handle: p.handle, profileName: p.profileName, usersName: p.usersName, accounts: checkedAccounts)
            updateProfile(with: profileUpdate)
        }
    }
    
    func chooseAccountsViewControllerDidCancel(_ controller: ChooseAccountsViewController) {
        dismiss(animated: true, completion: nil)
    }
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
        
        let appURL = NSURL(string: appURLString)
        let webURL = NSURL(string: webURLString)
        let application = UIApplication.shared
        
        if let appURL = appURL, application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else if let webURL = webURL {
            application.open(webURL as URL)
        }
    }
}

// MARK: - Segue Control
extension EditProfileViewController {
    internal func getIdList(from profile: PryntProfile?) -> [AccountId] {
        var accountIds = [AccountId]()
        guard let accts = profile?.accounts else { return accountIds }
        for each in accts {
            accountIds.append(each.id)
        }
        return accountIds
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewAccountsSegue" {
            let controller = segue.destination as! ChooseAccountsViewController
            controller.user = self.user
            controller.accounts = self.user.accounts
            controller.delegate = self
            controller.checkedAccounts = getIdList(from: profileToEdit)
        }
    }
}
