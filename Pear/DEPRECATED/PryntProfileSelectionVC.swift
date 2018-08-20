//
//  PryntProfileSelectionVC.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
/*import FirebaseDatabase

class PryntProfileSelectionVC: PearViewController {
    
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

extension PryntProfileSelectionVC {
    func updateInterface(with profile: SocialProfile?) {
        if let _ = loadedProfile {
            titleLabel.text = "Pearing with \(loadedProfile!.getUsersName()!)"
        }
    }
}

// MARK: - TableView Data Source
extension PryntProfileSelectionVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if activeUser != nil && activeUser!.profiles.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && activeUser != nil && activeUser!.profiles.count > 0 {
            return activeUser!.profiles.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")
        
        let profileNameLabel = cell?.viewWithTag(100) as? UILabel
        if activeUser != nil && activeUser!.profiles.count > 0 && indexPath.section == 0 {
            profileNameLabel?.text = activeUser!.profiles[indexPath.row].getName()
        } else {
            profileNameLabel?.text = "none"
        }
        
        return cell!
    }
}

// MARK: - TableView Delegate
extension PryntProfileSelectionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // segue to correct profile
        if indexPath.section == 1 || activeUser?.profiles.count == 0 {
            performSegue(withIdentifier: "confirmPryntProfilesSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "confirmPryntProfilesSegue", sender: activeUser!.profiles[indexPath.row])
        }
    }
}

extension PryntProfileSelectionVC {
    
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
            var profileUsersName = "ProfileUsersName"
            var profileHandle = "ProfileHandle"
            
            for service in profileDict {
                if service.key == "!ProfileName" {
                    profileName = service.value
                } else if service.key == "!UsersName" {
                    profileUsersName = service.value
                } else if service.key == "!Handle" {
                    profileHandle = service.value
                } else if service.key != "!ProfileId" {
                    let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                   handle: SocialProfile.parseSocialHandle(service.value),
                                                   ranking: SocialProfile.parseRanking(service.value))
                    loadedServices.append(newService)
                }
            }
            tempProfile = SocialProfile(name: profileName, services: loadedServices, handle: profileHandle, usersName: profileUsersName)
            tempProfile.setProfileID(id: profileId)
            
            return tempProfile
        } else {
            return nil
        }
    }
}

extension PryntProfileSelectionVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "confirmPryntProfilesSegue" {
            let controller = segue.destination as? ConfirmPryntProfilesVC
            if let socialProfile = sender as? SocialProfile {
                controller?.profileToShare = socialProfile
            }
            controller?.activeUser = activeUser
            controller?.scannedProfile = loadedProfile
            controller?.databaseRef = databaseRef
        }*/
    }
}
*/
