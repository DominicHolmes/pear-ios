//
//  CreateSocialProfileViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class CreateSocialProfileViewController : PearViewController {
    
    @IBOutlet weak var socialProfileTextField : UITextField!
    @IBOutlet weak var createSocialProfileButton : UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SocialProfileConstructionSegue" {
            let controller = segue.destination as! SocialProfileConstructionViewController
            controller.databaseRef = self.databaseRef
            controller.activeUser = self.activeUser
        }
    }
    
    @IBAction func textFieldValueValueChanged() {
        if socialProfileTextField.hasText {
            createSocialProfileButton.isEnabled = true
        } else {
            createSocialProfileButton.isEnabled = false
        }
    }
    
    @IBAction func createSocialProfileButtonTapped() {
        if socialProfileNameValid() && socialProfileTextField.hasText {
            performSegue(withIdentifier: "SocialProfileConstructionSegue", sender: socialProfileTextField.text!)
        }
    }
    
    func socialProfileNameValid() -> Bool {
        return true
    }
    
}
