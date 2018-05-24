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
    
    var transactionId: String?
    let secondaryProfileId: String!
    let primaryProfileId: String?
    private var primaryApproved: Bool = false
    private var secondaryApproved: Bool = false
    private var secondaryDenied: Bool = false
    
    var primaryName = "TestName"
    
    var approval: Bool = false
    
    private var dateOfCompletion: Date?
    
    init(primaryId: String?, secondaryId: String!, perspective: PearTransactionPerspective) {
        self.primaryProfileId = primaryId
        self.secondaryProfileId = secondaryId
        switch perspective {
        case .primary: primaryApproved = true
        case .secondary: secondaryApproved = true
        }
        updateTransactionState()
    }
    
    private func updateTransactionState() {
        approval = primaryApproved && secondaryApproved
        switch approval {
        case true: transactionState = .approved
        case false: transactionState = .waiting
        }
    }
    
    convenience init(of dict: Dictionary<String, String>, with perspective: PearTransactionPerspective) {
        self.init(primaryId: dict["primaryProfileId"], secondaryId: dict["secondaryProfileId"], perspective: perspective)
        self.transactionId = dict["transactionId"]
        
        if dict["primaryApproved"] == "true" {
            self.primaryApproved = true
        }
        if dict["secondaryApproved"] == "true" {
            self.primaryApproved = true
        }
        
        updateTransactionState()
    }
    
}

// Mark: - controller-facing methods
extension PearTransaction {
    
    func getTransactionState() -> PearTransactionState {
        return transactionState
    }
    
    func getPrimaryClearance() -> Bool {
        return primaryApproved
    }
    
    func getSecondaryClearance() -> Bool {
        return secondaryApproved
    }
    
    func hasFirebaseID() -> Bool {
        return (transactionId != nil)
    }
    
    func updateTransaction(with pendingTransaction: PearPendingTransaction) {
        secondaryApproved = pendingTransaction.isApproved()
        if pendingTransaction.isDenied() {
            transactionState = .denied
        } else if secondaryApproved {
            transactionState = .approved
        } else {
            transactionState = .waiting
        }
    }
    
    func getFirebaseEncoding() -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        dict["primaryName"] = "blah"
        dict["primaryHandle"] = "blah"
        dict["secondaryName"] = "blah"
        dict["secondaryHandle"] = "blah"
        
        dict["transactionId"] = self.transactionId
        
        if let _ = primaryProfileId { dict["primaryProfileID"] = self.primaryProfileId! }
        dict["primaryApproved"] = self.primaryApproved.description
        dict["secondaryApproved"] = self.secondaryApproved.description
        dict["secondaryProfileID"] = self.secondaryProfileId
        
        dict["state"] = self.transactionState.rawValue
        if let _ = dateOfCompletion { dict["completionDate"] = Date.firebaseDateString(from: dateOfCompletion!) }
        
        return dict
    }
}
