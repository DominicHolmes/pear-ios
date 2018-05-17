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

enum PearTransactionState {
    case waiting
    case approved
}

class PearTransaction {
    
    private var transactionState: PearTransactionState = .waiting
    
    private var primaryApproval: Bool = false
    private var secondaryApproval: Bool = false
    private var overallApproval: Bool = false
    
    private var primaryProfileID: Int?
    private var secondaryProfileID: Int?
    private var dateOfCompletion: Date?
    
    init(primary primaryID: Int!, secondary secondaryID: Int!, _ perspective: PearTransactionPerspective) {
        self.primaryProfileID = primaryID
        self.secondaryProfileID = secondaryID
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

// Mark: - User-facing methods
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
    
    func getPrimaryID() -> Int? {
        return primaryProfileID
    }
    
    func getSecondaryID() -> Int? {
        return secondaryProfileID
    }
}
