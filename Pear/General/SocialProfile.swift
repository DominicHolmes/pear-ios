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
    
    private var usersName: String!
    private var handle: String!
    
    var activeUser: PearUser? {
        didSet {
            if activeUser != nil {
                self.handle = activeUser!.username + "-" + profileName.lowercased()
                self.usersName = activeUser!.firstName
            }
        }
    }
    
    init(name : String!, services : [SocialService]?) {
        self.profileName = name
        self.socialServices = services
    }
    
    init(of dict: Dictionary<String, String>) {
        self.profileName = dict["!ProfileName"]
        self.profileID = dict["!ProfileId"]
        
        var loadedServices = [SocialService]()
        for eachService in dict {
            dump(eachService.key)
            if ((eachService.key != "!ProfileName") && (eachService.key != "!ProfileId")) {
                let newService = SocialService(socialService: SocialServiceType(rawValue: eachService.key),
                                               handle: SocialProfile.parseHandle(eachService.value),
                                               ranking: SocialProfile.parseRanking(eachService.value))
                loadedServices.append(newService)
            }
        }
        self.socialServices = loadedServices
    }
    
    func getName() -> String! { return profileName }
    func getHandle() -> String! { return handle }
    func getUsersName() -> String! { return usersName }
    
    func getServices() -> [SocialService]? { return socialServices }
    func setServices(services: [SocialService]?) { socialServices = services }
    
    func hasProfileID() -> Bool { return profileID != nil }
    func setProfileID(id: String) { self.profileID = id }
    func getProfileID() -> String { return profileID! }
    
    func getFirebaseEncoding() -> [String: String]! {
        var filteredServices = Dictionary<String, String>()
        if let _ = socialServices {
            filteredServices["!ProfileName"] = self.profileName
            filteredServices["!ProfileId"] = self.profileID
            for eachIndex in socialServices!.indices {
                var service: SocialService! = socialServices![eachIndex]
                service.ranking = eachIndex
                let valueString: String! = "(\(service!.ranking!)): " + (service!.handle)!
                filteredServices[service.socialService.rawValue] = valueString
            }
        }
        return filteredServices
    }
    
}

extension SocialProfile {
    
    static func parseHandle(_ string: String) -> String {
        let components = string.components(separatedBy: "): ")
        if components.count > 2 {
            var handle = ""
            for each in components where each != components.first {
                handle += each
            }
            return handle
        } else if components.count == 2 {
            return components[1]
        } else {
            return ""
        }
    }
    
    static func parseRanking(_ string: String) -> Int {
        let components = string.components(separatedBy: ["(", ")"])
        if let ranking = Int(components[1]) {
            return ranking
        } else {
            return 0
        }
    }
}
