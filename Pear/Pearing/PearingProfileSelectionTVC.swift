//
//  PearingProfileSelectionTableViewController.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PearProfileSelectionTVC: PearTableViewController {
    
    var scannedCode : String? {
        didSet {
            if scannedCode != nil { self.attemptLoadSocialProfile(with: scannedCode!) }
        }
    }
    
    var profileLoadingComplete : Bool = false {
        didSet {
            if profileLoadingComplete {
                revealProfileSelectionScreen()
            }
        }
    }
    
    func revealProfileSelectionScreen() {
        // end animation, show screen
    }
    
}

extension PearProfileSelectionTVC {
    
    func attemptLoadSocialProfile(with id: String) {
        let profilesRef = databaseRef.child("allSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                self.loadSocialProfile(ofId: id, withSnapshot: snapshot)
            }
            print("Done!!")
            //self.performSegue(withIdentifier: "LoginCompletionSegue", sender: nil)
        })
    }
    
    func loadSocialProfile(ofId profileId: String, withSnapshot snapshot: DataSnapshot) {
        var loadedProfile: SocialProfile
        
        if let profileDict = snapshot.value as? [String: String] {
            var loadedServices = [SocialService]()
            var profileName = "ProfileName"
            let profileId = profileId
            for service in profileDict {
                if service.key == "!ProfileName" {
                    profileName = service.value
                } else if service.key != "!ProfileId" {
                    let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                   handle: SocialProfile.parseHandle(service.value),
                                                   ranking: SocialProfile.parseRanking(service.value))
                    loadedServices.append(newService)
                }
            }
            loadedProfile = SocialProfile(name: profileName, services: loadedServices)
            loadedProfile.setProfileID(id: profileId)
            dump(loadedProfile)
        }
    }
}
