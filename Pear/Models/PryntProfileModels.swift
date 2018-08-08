//
//  PryntProfileModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/7/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

struct PryntProfile: Codable {
    let handle: String
    let profileName: String
    let usersName: String
    let user: String
    
    let accounts: [ServiceProfile]
}

struct ServiceProfile: Codable {
    let service: SocialServiceType
    let handle: String
    let ranking: Int
}
