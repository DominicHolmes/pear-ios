//
//  CreateSocialProfileViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class CreateSocialProfileViewController: PryntViewController {
    
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileHandleTextField: UITextField!
    @IBOutlet weak var createPryntProfileButton: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SocialProfileConstructionSegue" {
            let controller = segue.destination as! SocialProfileConstructionViewController
            //controller.user = self.activeUser
            //controller.pryntProfile = sender as! PryntProfile
        }
    }
    
    @IBAction func textFieldValueValueChanged() {
        if profileNameTextField.hasText && profileHandleTextField.hasText {
            createPryntProfileButton.isEnabled = true
        } else {
            createPryntProfileButton.isEnabled = false
        }
    }
    
    @IBAction func createSocialProfileButtonTapped() {
        if fieldsValid(), let handle = profileHandleTextField.text, let name = profileNameTextField.text {
            let profileSkeleton = PryntProfileCreate(userId: user.id, handle: handle, profileName: name, accounts: nil)
            
            ProfileNetworkingManager.shared.createProfile(from: profileSkeleton) { (success, profile) in
                if success, let profile = profile {
                    user.add(profile)
                }
            }
            performSegue(withIdentifier: "SocialProfileConstructionSegue", sender: socialProfile)
        }
    }
}

extension CreateSocialProfileViewController {
    
    fileprivate func fieldsValid() -> Bool { return profileHandleValid() && profileNameValid() }
    
    // TODO: Implement error checking on these methods
    fileprivate func profileHandleValid() -> Bool {
        return true
    }
    
    fileprivate func profileNameValid() -> Bool {
        return true
    }
    
}
