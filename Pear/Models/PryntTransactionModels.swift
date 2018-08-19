//
//  PryntTransactionModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/7/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

typealias TransactionId = String

struct TransactionHTTPSResponse: Codable {
    let status: Bool
    let transaction: Transaction?
}

struct TransactionCreate: Codable {
    let id: UserId
    let profileId: ProfileId
}

struct TransactionAccept: Codable {
    let id: UserId
    let transactionId: TransactionId
    let secondaryApproval: Bool
    let profileId: ProfileId
}

struct Transaction: Codable {
    let primaryApproval: Bool
    let primaryHandle: String
    let primaryName: String
    let primaryProfileId: ProfileId
    let primaryUsersName: String
    let primaryUser: UserId
    
    let secondaryApproval: Bool
    let secondaryHandle: String?
    let secondaryName: String?
    let secondaryProfileId: ProfileId?
    let secondaryUsersName: String?
    let secondaryUser: UserId?
    
    let state: TransactionState
    let id: TransactionId
}

struct FinishedTransaction: Codable {
    let transaction: Transaction
    let primaryProfile: PryntProfile
    let secondaryProfile: PryntProfile?
}

enum TransactionState: String, Codable {
    case COMPLETE
    case PENDING
}
