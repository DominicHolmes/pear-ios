//
//  PearTransaction.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

// Primary user is the whoever initiates the Pear (through scanning, username, etc.)
// Secondary is the one displaying a QR code

enum PearTransactionPerspective {
    case primary
    case secondary
}

enum PearTransactionState : String {
    case waiting
    case approved
    case denied
}

class PearTransaction {
    
    private var transactionState: PearTransactionState = .waiting
    
    private var firebaseID: String?
    
    private var primaryProfile: SocialProfile? {
        didSet {
            self.primaryName = primaryProfile?.getName()
            self.primaryHandle = primaryProfile?.getHandle()
            self.primaryUsersName = primaryProfile?.getUsersName()
        }
    }
    
    var primaryName: String?
    var primaryHandle: String?
    var primaryUsersName: String?
    
    private var secondaryProfile: SocialProfile! {
        didSet {
            self.secondaryName = primaryProfile?.getName()
            self.secondaryHandle = primaryProfile?.getHandle()
            self.secondaryUsersName = primaryProfile?.getUsersName()
        }
    }
    
    var secondaryName: String?
    var secondaryHandle: String?
    var secondaryUsersName: String?
    
    private var primaryApproval: Bool = false
    private var secondaryApproval: Bool = false
    private var overallApproval: Bool = false
    
    private let primaryProfileID: String?
    private let secondaryProfileID: String!
    private var dateOfCompletion: Date?
    
    init(primary: SocialProfile?, secondary: SocialProfile!, perspective: PearTransactionPerspective) {
        self.primaryProfile = primary
        self.secondaryProfile = secondary
        self.primaryProfileID = primary?.getProfileID()
        self.secondaryProfileID = secondary.getProfileID()
        switch perspective {
        case .primary: primaryApproval = true
        case .secondary: secondaryApproval = true
        }
        updateTransactionState()
    }
    
    private func updateTransactionState() {
        overallApproval = primaryApproval && secondaryApproval
        switch overallApproval {
        case true: transactionState = .approved
        case false: transactionState = .waiting
        }
    }
}

// Mark: - controller-facing methods
extension PearTransaction {
    
    func getTransactionState() -> PearTransactionState {
        return transactionState
    }
    
    func getPrimaryClearance() -> Bool {
        return primaryApproval
    }
    
    func getSecondaryClearance() -> Bool {
        return secondaryApproval
    }
    
    func getPrimaryID() -> String? {
        return primaryProfileID
    }
    
    func getSecondaryID() -> String {
        return secondaryProfileID
    }
    
    func hasFirebaseID() -> Bool {
        return !(firebaseID == nil)
    }
    
    func getFirebaseID() -> String {
        return firebaseID!
    }
    
    func setFirebaseID(_ id: String) {
        firebaseID = id
    }
    
    func updateTransaction(with pendingTransaction: PearPendingTransaction) {
        secondaryApproval = pendingTransaction.isApproved()
        if pendingTransaction.isDenied() {
            transactionState = .denied
        } else if secondaryApproval {
            transactionState = .approved
        } else {
            transactionState = .waiting
        }
    }
    
    func getFirebaseEncoding() -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        if let _ = primaryName { dict["primaryName"] = self.primaryName! }
        if let _ = primaryHandle { dict["primaryHandle"] = self.primaryHandle! }
        if let _ = primaryUsersName { dict["primaryUsersName"] = self.primaryUsersName! }
        if let _ = secondaryName { dict["secondaryName"] = self.secondaryName! }
        if let _ = secondaryHandle { dict["secondaryHandle"] = self.secondaryHandle! }
        if let _ = secondaryUsersName { dict["secondaryUsersName"] = self.secondaryUsersName! }
        
        if let _ = primaryProfileID { dict["primaryProfileID"] = self.primaryProfileID! }
        dict["primaryApproval"] = self.primaryApproval.description
        
        dict["secondaryApproval"] = self.secondaryApproval.description
        dict["secondaryProfileID"] = self.secondaryProfileID
        
        dict["state"] = self.transactionState.rawValue
        if let _ = dateOfCompletion { dict["completionDate"] = Date.firebaseDateString(from: dateOfCompletion!) }
        
        return dict
    }
}
