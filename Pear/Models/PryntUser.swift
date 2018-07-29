//
//  PryntUser.swift
//  Prynt
//
//  Created by Dominic Holmes on 7/28/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let id: String
    let username: String
    let nameFirst: String
    let nameLast: String
}

struct PryntProfile: Codable {
    let handle: String
    let profileName: String
    let usersName: String
    let user: String
    //let accounts: [PryntProfileService]
    
}

struct ServiceProfile: Codable {
    
}

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
