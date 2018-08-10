//
//  PryntUser.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class PryntUser {
    
    var firstName: String!
    var lastName: String!
    var username: String!
    let id: String!
    var profiles: [PryntProfile]?
    
    init(firstName: String, lastName: String, username: String, id: String, profiles: [PryntProfile]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.id = id
        self.profiles = profiles
    }
    
    init(from userInfo: UserInfo) {
        self.firstName = userInfo.nameFirst
        self.lastName = userInfo.nameLast
        self.id = userInfo.id
        self.username = userInfo.username
    }
}

// MARK: - Profiles Networking
extension PryntUser {
    func requestAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: self.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.profiles = profiles
            } else {
                dump(profiles)
            }
        }
    }
}

// MARK: - Profile Creation
extension PryntUser {
    func add(_ profile: PryntProfile) {
        if profiles == nil { profiles = [PryntProfile]() }
        
        if let replacedProfile = profiles!.index(where: { (p) -> Bool in
            return profile.id == p.id
        }) {
            profiles![replacedProfile] = profile
        } else {
            profiles!.append(profile)
        }
    }
}
