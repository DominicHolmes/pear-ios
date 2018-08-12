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
    let service: SocialServiceType
    let handle: String
}

struct Account: Codable {
    let service: SocialServiceType
    let handle: String
    let id: AccountId
    
    enum CodingKeys: String, CodingKey {
        case service = "service"
        case handle = "handle"
        case id = "_id"
    }
}
