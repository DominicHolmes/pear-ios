//
//  InitialRegistrationViewController.swift
//  Pear
//
//  Created by dominic on 3/29/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class InitialRegistrationViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    var activeUser: PearUser?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var confirmDetailsButton: UIButton!
    
    @IBAction func firstNameFieldNextButtonPressed() {
        lastNameTextField.becomeFirstResponder()
    }
    
    @IBAction func lastNameFieldNextButtonPressed() {
        usernameTextField.becomeFirstResponder()
    }

    @IBAction func usernameFieldNextButtonPressed() {
        self.view.endEditing(true)
    }
    
    @IBAction func confirmDetailsButtonPressed() {
        confirmDetails()
    }
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldValueValueChanged() {
        if firstNameTextField.hasText && lastNameTextField.hasText &&
            usernameTextField.hasText {
            confirmDetailsButton.isEnabled = true
        } else {
            confirmDetailsButton.isEnabled = false
        }
    }
    
    func confirmDetails() {
        let errors = findErrors()
        
        if errors.isEmpty {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.displayAlert("Error", error!.localizedDescription, [""], false)
                } else if user != nil {
                    self.saveNewReviveUser(user!)
                    self.activeUser = ReviveUser(fname: self.firstNameTextField.text!,
                                                 lname: self.lastNameTextField.text!,
                                                 id: user!.uid,
                                                 isAdmin: false)
                    self.displayAlert("Success!", "New user with username \(self.emailTextField.text!) created. Sign up for a challenge to get started!", [""], true)
                }
            }
        } else {
            self.displayAlert("Could not create new user", "Please fix the following errors:", errors, false)
        }
    }
    
    func saveNewReviveUser(_ user: User) {
        let uid = user.uid
        let newUserRef = databaseRef.child("users").child(uid)
        newUserRef.setValue(["name-first": firstNameTextField.text!,
                             "name-last": lastNameTextField.text!,
                             "id": uid,
                             "isAdmin": "false"])
        
    }
    
    func findErrors() -> [String] {
        var errors = [String]()

        if !firstNameTextField.hasText {
            errors.append("\n- Enter a first name")
        }
        if !lastNameTextField.hasText {
            errors.append("\n- Enter a last name")
        }
        if !usernameTextField.hasText {
        	if usernameValid() {
        		if usernameTaken() {
        			errors.append("\n- Username taken, please try another")
        		}
        	} else {
        		errors.append("\n- Username should be lowercase, and contain only letters and numbers, and be at least 3 char")
        	}
        	if usernameTaken() {

        	}
        }
        // other username checks
        
        if emailTextField.hasText {
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            do {
                let regex = try NSRegularExpression(pattern: emailRegEx)
                let nsString = emailTextField.text! as NSString
                let results = regex.matches(in: emailTextField.text!, range: NSRange(location: 0, length: nsString.length))
                if results.count == 0 {
                    errors.append("\n- Enter a valid email address")
                }
            } catch _ as NSError {
                errors.append("\n- Enter a valid email address")
            }
        } else {
            errors.append("\n- Enter an email address")
        }
        
        return errors
    }
    
    func displayAlert(_ title: String, _ messageHeader: String, _ errors: [String], _ toPayment: Bool) {
        var message = messageHeader
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpChooseChallenge" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! SignUpChooseChallengeTableViewController
            controller.databaseRef = self.databaseRef
            controller.activeUser = self.activeUser
        }
    }

    /*
    if passwordTextField.hasText {
            if (passwordTextField.text!.count < 6 || passwordTextField.text!.count > 20) {
                errors.append("\n- Password must be 6-20 characters long")
            }
            if passwordTextField.text!.contains(" ") {
                errors.append("\n- Password cannot contain spaces")
            }
            if passwordConfirmTextField.text != passwordTextField.text {
            	errors.append("\n- Password and confirm password are not identical")
        	}
        } else {
            errors.append("\n- Enter a valid password")
        }*/
}
