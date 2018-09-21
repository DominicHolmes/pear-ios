//
//  PryntRegistrationViewController.swift
//  Prynt
//
//  Created by dominic on 3/29/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseAuth

class PryntRegistrationViewController: PryntGenericRegistrationViewController {
    
    // Class variables
    var newUserUID: String?
    
    // Outlets, actions
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmDetailsButton: UIButton!
    
    @IBAction func firstNameFieldNextButtonPressed() { lastNameTextField.becomeFirstResponder() }
    @IBAction func lastNameFieldNextButtonPressed() { usernameTextField.becomeFirstResponder() }
    @IBAction func usernameFieldNextButtonPressed() { self.view.endEditing(true) }
    @IBAction func confirmDetailsButtonPressed() { confirmDetails() }
    @IBAction func textFieldValueValueChanged() {
        if firstNameTextField.hasText && lastNameTextField.hasText &&
            usernameTextField.hasText {
            confirmDetailsButton.isEnabled = true
        } else {
            confirmDetailsButton.isEnabled = false
        }
    }
    
    fileprivate func confirmDetails() {
        let errors = findErrors()
        
        if errors.isEmpty {
            attemptUserCreation()
        } else {
            self.displayAlert("Please try again", "Please correct the following:", errors, false)
        }
    }
    
    fileprivate func attemptUserCreation() {
        guard let uid = newUserUID, let username = usernameTextField.text, let first = firstNameTextField.text, let last = lastNameTextField.text else { return }
        let proposedUser = UserInfo(id: uid, username: username, nameFirst: first, nameLast: last)
        UserNetworkingManager.shared.createUser(from: proposedUser) { (success, user) in
            if success, let user = user {
                let pryntUser = PryntUser(from: user)
                self.performSegue(withIdentifier: "PostRegistrationSegue", sender: pryntUser)
            } else {
                self.displayAlert("Username taken", "Please try again.", [], false)
            }
        }
    }
}

// MARK: - Error Handling
extension PryntRegistrationViewController {
    fileprivate func findErrors() -> [String] {
        var errors = [String]()
        
        if !(firstNameTextField.hasText) {
            errors.append("\n- Enter a first name")
        }
        if !(lastNameTextField.hasText) {
            errors.append("\n- Enter a last name")
        }
        if !(usernameTextField.hasText) {
            errors.append("\n- Enter a username")
        } else {
            if usernameValid() {
                if usernameTaken() {
                    errors.append("\n- Username taken, please try another")
                }
            } else {
                errors.append("\n- Username should be lowercase, and contain only letters and numbers, and be at least 3 characters.")
            }
        }
        
        return errors
    }
    // MARK: - TODO
    fileprivate func usernameValid() -> Bool {
        return true
    }
    fileprivate func usernameTaken() -> Bool {
        return false
    }
}

// MARK: - Segue Control
extension PryntRegistrationViewController {
    override internal func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegistrationCompletedSegue", let sender = sender as? PryntUser {
            let navController = segue.destination as! UINavigationController
            let pageController = navController.topViewController as! RootPageViewController
            pageController.user = sender
        }
    }
}
