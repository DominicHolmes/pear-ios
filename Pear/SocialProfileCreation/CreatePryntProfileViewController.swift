//
//  CreatePryntProfileViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class CreatePryntProfileViewController: PryntViewController {
    
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileHandleTextField: UITextField!
    @IBOutlet weak var createPryntProfileButton: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPryntProfileSegue", let sender = sender as? PryntProfile {
            let controller = segue.destination as! EditPryntProfileViewController
            controller.user = self.user
            controller.profileToEdit = sender
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
                    self.user.add(profile)
                    self.performSegue(withIdentifier: "EditPryntProfileSegue", sender: profile)
                } else {
                    // TODO: Present error message to user
                }
            }
        }
    }
}

extension CreatePryntProfileViewController {
    
    fileprivate func fieldsValid() -> Bool { return profileHandleValid() && profileNameValid() }
    
    // TODO: Implement error checking on these methods
    fileprivate func profileHandleValid() -> Bool {
        return true
    }
    
    fileprivate func profileNameValid() -> Bool {
        return true
    }
    
}
