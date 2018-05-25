//
//  PearingProfileSelectionVC.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PearProfileSelectionVC: PearViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var scannedCode : String? {
        didSet {
            if scannedCode != nil { self.attemptLoadSocialProfile(with: scannedCode!) }
        }
    }
    
    var loadedProfile : SocialProfile? = nil {
        didSet {
            updateInterface(with: loadedProfile)
        }
    }
    
    func revealProfileSelectionScreen() {
        // end animation, show screen
    }
    
}

extension PearProfileSelectionVC {
    func updateInterface(with profile: SocialProfile?) {
        if let _ = loadedProfile {
            titleLabel.text = "Pearing with \(loadedProfile!.getName()!)"
        }
    }
}

// MARK: - TableView Data Source
extension PearProfileSelectionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && activeUser != nil {
            return activeUser!.profiles.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        if activeUser != nil {
            profileNameLabel?.text = activeUser!.profiles[indexPath.row].getName()
        }
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension PearProfileSelectionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
        performSegue(withIdentifier: "confirmPearProfilesSegue", sender: activeUser!.profiles[indexPath.row])
    }
}

extension PearProfileSelectionVC {
    
    func attemptLoadSocialProfile(with id: String) {
        let profilesRef = databaseRef.child("allSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                self.loadedProfile = self.loadSocialProfile(ofId: id, withSnapshot: snapshot)
                
            }
        })
    }
    
    func loadSocialProfile(ofId profileId: String, withSnapshot snapshot: DataSnapshot) -> SocialProfile? {
        
        var tempProfile: SocialProfile
        
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
            tempProfile = SocialProfile(name: profileName, services: loadedServices)
            tempProfile.setProfileID(id: profileId)
            
            return tempProfile
        } else {
            return nil
        }
    }
}

extension PearProfileSelectionVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmPearProfilesSegue" {
            let controller = segue.destination as? ConfirmPearProfilesVC
            if let socialProfile = sender as? SocialProfile {
                controller?.profileToShare = socialProfile
                controller?.activeUser = activeUser
                controller?.scannedProfile = loadedProfile
                controller?.databaseRef = databaseRef
            }
        }
    }
}
