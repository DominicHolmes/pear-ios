//
//  PryntAccount.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/10/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

struct AccountCreate: Codable {
    let service: SocialServiceType
    let handle: String
}

struct Account: Codable {
    let service: SocialServiceType
    let handle: String
    let id: String
}