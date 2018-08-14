//
//  PryntAccount.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/10/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

typealias AccountId = String

struct AccountHTTPSResponse: Codable {
    let status: Bool
    let account: Account?
}

struct AllAccountsHTTPSResponse: Codable {
    let status: Bool
    let accounts: [Account]?
}

struct AccountCreate: Codable {
    let userId: UserId
    let service: SocialServiceType
    let handle: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case handle = "handle"
        case service = "service"
    }
}

struct AccountUpdate: Codable {
    let userId: UserId
    let service: SocialServiceType
    let handle: String
    let id: AccountId
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case service = "service"
        case handle = "handle"
        case id = "accountId"
    }
}

struct Account: Codable {
    let userId: UserId
    let service: SocialServiceType
    let handle: String
    let id: AccountId
    
    enum CodingKeys: String, CodingKey {
        case userId = "user"
        case service = "service"
        case handle = "handle"
        case id = "id"
    }
}

struct NestedAccount: Codable {
    let userId: UserId
    let service: SocialServiceType
    let handle: String
    let id: AccountId
    
    enum CodingKeys: String, CodingKey {
        case userId = "user"
        case service = "service"
        case handle = "handle"
        case id = "_id"
    }
}
