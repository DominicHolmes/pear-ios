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
    /*
    if let profilesDict = snapshot.value as? [String: Any] {
        for eachProfileId in profilesDict.keys {
            if let eachProfile = profilesDict[eachProfileId] as? [String : String] {
                var loadedServices = [SocialService]()
                var profileName = "Profile"
                let profileId = eachProfileId
                for service in eachProfile {
                    if service.key == "!ProfileName" {
                        profileName = service.value
                    } else if service.key != "!ProfileId" {
                        let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                       handle: SocialProfile.parseHandle(service.value),
                                                       ranking: SocialProfile.parseRanking(service.value))
                        loadedServices.append(newService)
                    }
                }
                let newProfile = SocialProfile(name: profileName, services: loadedServices)
                newProfile.setProfileID(id: profileId)
                loadedSocialProfiles.append(newProfile)
            }
        }
    }*/
    
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
            filteredServices["!ProfileId"] = self.profileID
            for eachIndex in socialServices!.indices {
                let service: SocialService! = socialServices![eachIndex]
                let valueString: String! = "(\(eachIndex)): " + (service!.handle)!
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
        if let ranking = Int(components[0]) {
            return ranking
        } else {
            return 0
        }
    }
}
