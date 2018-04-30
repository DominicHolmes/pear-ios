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
    private var profileID : String?
    
    init(name : String!, services : [SocialService]?) {
        self.profileName = name
        self.socialServices = services
    }
    
    func getName() -> String! {
        return profileName
    }
    
    func getServices() -> [SocialService]? { return socialServices }
    func setServices(services: [SocialService]?) { socialServices = services }
    
    func hasProfileID() -> Bool { return profileID != nil }
    func setProfileID(id: String) { self.profileID = id }
    func getProfileID() -> String { return profileID! }
    
    func getFirebaseEncoding() -> [String: String]! {
        var filteredServices = Dictionary<String, String>()
        if let _ = socialServices {
            filteredServices["!ProfileName"] = self.profileName
            filteredServices["!ProfileID"] = self.profileID
            for eachIndex in socialServices!.indices {
                let service: SocialService! = socialServices![eachIndex]
                let valueString: String! = "(\(eachIndex)): " + (service!.handle)!
                filteredServices[service.socialService.rawValue] = valueString
            }
        }
        dump(filteredServices)
        return filteredServices
    }
    
}
