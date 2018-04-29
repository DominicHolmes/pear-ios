//
//  SocialProfile.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class SocialProfile: NSObject {
    
    private var profileName : String!
    private var socialServices : [SocialService]?
    
    init(name : String!, services : [SocialService]?) {
        self.profileName = name
        self.socialServices = services
    }
    
    func getName() -> String! {
        return profileName
    }
    
    func getServices() -> [SocialService]? {
        return socialServices
    }
}
