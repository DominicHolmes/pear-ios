//
//  PryntUserModels.swift
//  Prynt
//
//  Created by Dominic Holmes on 7/28/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

struct UserInfoHTTPSResponse: Codable {
    let status: Bool
    let user: UserInfo?
}

struct UserInfo: Codable {
    let id: String
    let username: String
    let nameFirst: String
    let nameLast: String
}
