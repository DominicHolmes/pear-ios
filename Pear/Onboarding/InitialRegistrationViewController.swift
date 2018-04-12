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
            performSegue(withIdentifier: "FinalRegistrationSegue",
                         sender: (firstNameTextField.text!, lastNameTextField.text!, usernameTextField.text!))
        } else {
            self.displayAlert("Please try again", "Please correct the following:", errors, false)
        }
    }
    
    func findErrors() -> [String] {
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
    
    func usernameValid() -> Bool {
        return true
    }
    
    func usernameTaken() -> Bool {
        return false
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
        if segue.identifier == "FinalRegistrationSegue" {
            let controller = segue.destination as! FinalRegistrationViewController
            controller.databaseRef = self.databaseRef
            controller.names = sender as? (String, String, String)
        }
    }
}
