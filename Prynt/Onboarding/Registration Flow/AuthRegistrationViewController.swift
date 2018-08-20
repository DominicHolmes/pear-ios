//
//  AuthRegistrationViewController.swift
//  Pear
//
//  Created by dominic on 3/29/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthRegistrationViewController: PryntGenericRegistrationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Class variables
    var newUserUID: String?
    
    // Outlets, actions
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBAction func emailFieldNextButtonPressed() { passwordTextField.becomeFirstResponder() }
    @IBAction func passwordFieldNextButtonPressed() { passwordConfirmTextField.becomeFirstResponder() }
    @IBAction func passwordConfirmFieldNextButtonPressed() { self.view.endEditing(true) }
    @IBAction func createAccountButtonPressed() { createAccount() }
    @IBAction func cancelButtonTapped() { dismiss(animated: true, completion: nil) }
    @IBAction func privacyPolicyButtonPressed() {
        if let url = URL(string: "https://www.iubenda.com/privacy-policy/8203081") {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
            }
        }
    }
    @IBAction func textFieldValueValueChanged() {
        if passwordTextField.hasText && passwordConfirmTextField.hasText &&
            emailTextField.hasText {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
    }
}

// MARK: - Firebase Auth UUID Creation
extension AuthRegistrationViewController {
    internal func createAccount() {
        let errors = findErrors()
        if errors.isEmpty {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.displayAlert("Error", error!.localizedDescription, [""], false)
                } else if let user = user {
                    self.newUserUID = user.uid
                    self.displayAlert("Success!", "New account with email \(self.emailTextField.text!) created. Welcome to Pear!", [""], true)
                }
            }
        } else {
            self.displayAlert("Could not create new user", "Please fix the following errors:", errors, false)
        }
    }
}

// MARK: - Error Checking
extension AuthRegistrationViewController {
    func findErrors() -> [String] {
        var errors = [String]()
        
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
        
        if passwordTextField.hasText {
            if (passwordTextField.text!.count < 6 || passwordTextField.text!.count > 20) {
                errors.append("\n- Password must be 6-20 characters long")
            }
            if passwordTextField.text!.contains(" ") {
                errors.append("\n- Password cannot contain spaces")
            }
        } else {
            errors.append("\n- Enter a valid password")
        }
        if passwordConfirmTextField.text != passwordTextField.text {
            errors.append("\n- Passwords are not identical")
        }
        return errors
    }
}

// MARK: - Segue Control
extension AuthRegistrationViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PearRegistrationSegue", let uid = newUserUID {
            let controller = segue.destination as! PearRegistrationViewController
            controller.newUserUID = uid
        }
    }
}
