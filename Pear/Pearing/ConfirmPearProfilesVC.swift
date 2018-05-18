//
//  PearingAnimationViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConfirmPearProfilesVC: PearViewController {
    
    var profileToShare : SocialProfile?
    var scannedProfile : SocialProfile?
    
    var transaction : PearTransaction?
    var pendingTransaction : PearPendingTransaction? {
        didSet {
            if let _ = pendingTransaction {
                transaction?.updateTransaction(with: pendingTransaction!)
            }
            processTransactionState()
        }
    }
    
    @IBOutlet weak var topProfileView : RadialProgressView!
    @IBOutlet weak var topProfileImageView : UIImageView!
    @IBOutlet weak var bottomProfileView : RadialProgressView!
    @IBOutlet weak var bottomProfileImageView : UIImageView!
    
    @IBOutlet weak var topProfileTrailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var topProfileWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var bottomProfileLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var bottomProfileWidthConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutImageViewInitialPositions()
        executeTransaction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfileImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //beginPearingAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processTransactionState() {
        if let trans = transaction {
            switch trans.getTransactionState() {
            case .approved: beginPearingAnimation()
                            saveTransaction(trans)
                            updatePrimaryUserTransactions()
                            deletePendingTransaction()
            case .denied: dismiss(animated: true, completion: nil)
            case .waiting: break //do nothing
            }
        }
    }
}

// Mark: - PearTransaction creation and validation
extension ConfirmPearProfilesVC {
    
    func executeTransaction() {
        initializeTransaction()
        saveTransaction(transaction!)
        initializePendingTransaction()
        savePendingTransaction(pendingTransaction!)
        observePendingTransaction()
    }
    
    func initializeTransaction() {
        self.transaction = PearTransaction(primary: profileToShare,
                                           secondary: scannedProfile!,
                                           perspective: .primary)
    }
    
    func saveTransaction(_ transaction: PearTransaction) {
        let transactionDatabaseRef: DatabaseReference!
        switch transaction.hasFirebaseID() {
        case true: transactionDatabaseRef = databaseRef.child("allTransactions").child(transaction.getFirebaseID())
        case false: transactionDatabaseRef = databaseRef.child("allTransactions").childByAutoId()
                    transaction.setFirebaseID(transactionDatabaseRef.key)
        }
        transactionDatabaseRef.setValue(transaction.getFirebaseEncoding())
    }
    
    func initializePendingTransaction() {
        self.pendingTransaction = PearPendingTransaction(transactionID: transaction!.getFirebaseID(),
                                                         secondaryProfileID: transaction!.getSecondaryID())
    }
    
    func savePendingTransaction(_ pendingTransaction: PearPendingTransaction) {
        let pendingDatabaseRef = databaseRef.child("pendingTransactions").child(
            pendingTransaction.secondaryProfileID).child(pendingTransaction.transactionID)
        pendingDatabaseRef.setValue(pendingTransaction.getFirebaseEncoding())
    }
    
    func observePendingTransaction() {
        let ref = databaseRef.child("pendingTransactions").child(
            pendingTransaction!.secondaryProfileID).child(pendingTransaction!.transactionID)
        ref.observe(.value, with: { snapshot in
            if let _ = snapshot.value, let dict = snapshot.value as? Dictionary<String, String> {
                self.pendingTransaction = PearPendingTransaction.init(of: dict)
            }
        })
    }
    
    func updatePrimaryUserTransactions() {
        let ref = databaseRef.child("usersTransactions").child(activeUser!.id).child(transaction!.getFirebaseID())
        ref.setValue(transaction!.getFirebaseStubEncoding())
    }
    
    func deletePendingTransaction() {
        let ref = databaseRef.child("pendingTransactions").child(
            pendingTransaction!.secondaryProfileID).child(pendingTransaction!.transactionID)
        ref.setValue(nil)
    }
}

extension ConfirmPearProfilesVC {
    /*func searchForProfile(withId profileId: String) {
        attemptLoadSocialProfile(with: profileId)
    }
    
    func attemptLoadSocialProfile(with id: String) {
        let profilesRef = databaseRef.child("allSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                self.loadSocialProfile(ofId: id, withSnapshot: snapshot)
            }
            print("Done!!")
            //self.performSegue(withIdentifier: "LoginCompletionSegue", sender: nil)
        })
    }
    
    func loadSocialProfile(ofId profileId: String, withSnapshot snapshot: DataSnapshot) {
        var loadedProfile: SocialProfile
        
        if let profileDict = snapshot.value as? [String: String] {
            var loadedServices = [SocialService]()
            var profileName = "ProfileName"
            let profileId = profileId
            for service in profileDict {
                if service.key == "!ProfileName" {
                    profileName = service.value
                } else if service.key != "!ProfileId" {
                    let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                   handle: SocialProfile.parseHandle(service.value),
                                                   ranking: SocialProfile.parseRanking(service.value))
                    loadedServices.append(newService)
                }
            }
            loadedProfile = SocialProfile(name: profileName, services: loadedServices)
            loadedProfile.setProfileID(id: profileId)
            dump(loadedProfile)
        }
    }*/
}

// Mark: - Pearing Animation
extension ConfirmPearProfilesVC {
    
    private func layoutImageViewInitialPositions() {
        self.topProfileTrailingConstraint.constant = self.view.layer.bounds.maxX
        self.bottomProfileLeadingConstraint.constant = self.view.layer.bounds.maxX
        self.view.layoutIfNeeded()
    }
    
    private func setupProfileImages() {
        topProfileImageView.setRounded()
        bottomProfileImageView.setRounded()
    }
    
    private func beginPearingAnimation() {

        topProfileView.isHidden = false
        bottomProfileView.isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.topProfileTrailingConstraint.constant =
                    (self.view.layer.bounds.maxX / 2.0) - (self.topProfileWidthConstraint.constant / 2.0)
                self.bottomProfileLeadingConstraint.constant =
                    (self.view.layer.bounds.maxX / 2.0) - (self.bottomProfileWidthConstraint.constant / 2.0)
                self.view.layoutIfNeeded()
            },
            completion: { (true) in
                self.animatePearingCircles()
            })
    }
    
    private func animatePearingCircles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            self.topProfileView.setValueAnimated(duration: 0.6, newProgressValue: 1.0)
            self.bottomProfileView.setValueAnimated(duration: 0.6, newProgressValue: 1.0)
        })
    }
}
