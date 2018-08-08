//
//  PryntTransactionModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/7/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let primaryApproval: Bool
    let primaryHandle: String
    let primaryProfileId: String
    let primaryUsersName: String
    
    let secondaryApproval: Bool
    let secondaryHandle: String
    let secondaryName: String
    let secondaryProfileId: String
    
    let state: TransactionState
    let id: String
}

struct TransactionResponse: Codable {
    let transaction: Transaction
    let primaryProfile: PryntProfile
    let secondaryProfile: PryntProfile
}

enum TransactionState: String, Codable {
    case COMPLETE
    case PENDING
}
