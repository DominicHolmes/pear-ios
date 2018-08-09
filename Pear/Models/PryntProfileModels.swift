//
//  PryntProfileModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/7/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

typealias ProfileId = String

struct PryntProfileHTTPSResponse: Codable {
    let status: Bool
    let profile: PryntProfile?
}

struct PryntProfileCreate: Codable {
    let userId: UserId
    let handle: String
    let profileName: String
    let accounts: [ServiceProfile]?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user"
        case handle = "handle"
        case profileName = "profileName"
        case accounts = "accounts"
    }
}

struct PryntProfile: Codable {
    let id: ProfileId
    let userId: UserId
    let handle: String
    let profileName: String
    let usersName: String
    let accounts: [ServiceProfile]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user"
        case handle = "handle"
        case profileName = "profileName"
        case usersName = "usersName"
        case accounts = "accounts"
    }
}

struct ServiceProfile: Codable {
    let service: SocialServiceType
    let handle: String
    let ranking: Int
}

struct PryntTransactionProfile: Codable {
    let handle: String
    let profileName: String
    let usersName: String
    let accounts: [ServiceProfile]?
}
