//
//  PryntUserModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 7/28/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

typealias UserId = String

struct UserInfoHTTPSResponse: Codable {
    let status: Bool
    let user: UserInfo?
}

struct UserInfo: Codable {
    let id: UserId
    let username: String
    let nameFirst: String
    let nameLast: String
}
