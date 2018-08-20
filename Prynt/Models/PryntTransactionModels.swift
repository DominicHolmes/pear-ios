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

struct AllTransactionsHTTPSResponse: Codable {
    let status: Bool
    let transactions: [Transaction]?
}

struct TransactionCreate: Codable {
    let id: UserId
    let profileId: ProfileId
}

struct TransactionAccept: Codable {
    let id: UserId
    let transactionId: TransactionId
    let secondaryApproval: Bool
    let profileId: ProfileId?
}

struct TransactionReciprocate: Codable {
    let id: UserId
    let transactionId: TransactionId
    let profileId: ProfileId
}

struct Transaction: Codable {
    let transaction: TransactionDetails
    let primaryProfile: PryntTransactionProfile
    let secondaryProfile: PryntTransactionProfile?
}

struct TransactionDetails: Codable {
    let primaryApproval: Bool
    let primaryHandle: String
    let primaryName: String
    let primaryProfileId: ProfileId
    let primaryUsersName: String
    
    let secondaryApproval: Bool
    let secondaryHandle: String?
    let secondaryName: String?
    let secondaryProfileId: ProfileId?
    let secondaryUsersName: String?
    
    let state: TransactionState
    let id: TransactionId
}

enum TransactionState: String, Codable {
    case COMPLETE
    case PENDING
}
