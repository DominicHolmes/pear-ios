//
//  ChooseProfileViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 9/2/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit


class ChooseProfileViewController: PryntTabViewController {
    
    var profiles: [PryntProfile]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override var user: PryntUser! {
        didSet {
            profiles = user.profiles
            fetchAllProfiles()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: user.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.user.profiles = profiles
                self.updateShownProfiles()
            } else {
                self.displayAlert("Error", "Could not fetch profiles. Please make sure you have access to internet and try again.", nil)
            }
        }
    }
    
    private func updateShownProfiles() {
        profiles = user.profiles
        collectionView.reloadData()
    }
    
}

// MARK: - Create Transaction Logic
extension ChooseProfileViewController {
    func initializeTransaction(with profile: PryntProfile) {
        let transactionCreate = TransactionCreate(id: user.id, profileId: profile.id)
        create(transactionCreate)
    }
    
    internal func create(_ transactionCreate: TransactionCreate) {
        TransactionNetworkingManager.shared.createTransaction(from: transactionCreate) { (success, transaction) in
            if success, let transaction = transaction {
                self.user.add(transaction)
                self.performSegue(withIdentifier: "PresentTransactionSegue", sender: transaction)
            } else {
                self.displayAlert("Error", "Couldn't create a QR code. Please try again later.", nil)
            }
        }
    }
}

// MARK: - CollectionView Data Source
extension ChooseProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (profiles?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClusterCell", for: indexPath)
        guard let profiles = profiles, indexPath.row < profiles.count else { return cell }
        let profile = profiles[indexPath.row]
        let accounts = profile.accounts ?? [Account]()
        
        for i in 0 ..< accounts.count {
            guard i < 3 else { return cell }
            
            let imageView = cell.viewWithTag(201 + i) as? UIImageView
            imageView?.image = UIImage(named: accounts[i].service.photoName)
        }
        
        let profileNameLabel = cell.viewWithTag(100) as? UILabel
        profileNameLabel?.text = profile.profileName
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension ChooseProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let profiles = profiles, indexPath.row < profiles.count else { return }
        let profile = profiles[indexPath.row]
        initializeTransaction(with: profile)
    }
}

// MARK: - Delete Profile Popover
extension ChooseProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        // TODO: Implement Profile Deletion
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
}

// MARK: - Segue Control
extension ChooseProfileViewController {
    
    // TODO: Hook up segue stuff
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentTransactionSegue", let sender = sender as? Transaction {
            let controller = segue.destination as! PresentTransactionViewController
            controller.user = self.user
            controller.transaction = sender
        }
    }
}
