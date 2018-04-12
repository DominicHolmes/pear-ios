//
//  FinalRegistrationViewController.swift
//  Pear
//
//  Created by dominic on 3/29/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FinalRegistrationViewController: PearViewController {
    
    var names: (String, String, String)? // first, last, username
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func emailFieldNextButtonPressed() {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func passwordFieldNextButtonPressed() {
        passwordConfirmTextField.becomeFirstResponder()
    }
    
    @IBAction func passwordConfirmFieldNextButtonPressed() {
        self.view.endEditing(true)
    }
    
    @IBAction func createAccountButtonPressed() {
        createAccount()
    }
    
    @IBAction func privacyPolicyButtonPressed() {
        if let url = URL(string: "https://www.iubenda.com/privacy-policy/8203081") {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
            }
        }
    }
    
    @IBAction func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldValueValueChanged() {
        if passwordTextField.hasText && passwordConfirmTextField.hasText &&
            emailTextField.hasText {
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.isEnabled = false
        }
    }
    
    func createAccount() {
        let errors = findErrors()
        
        if errors.isEmpty {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.displayAlert("Error", error!.localizedDescription, [""], false)
                } else if user != nil {
                    self.saveNewPearUser(user!)
                    self.activeUser = PearUser(fname: self.names!.0,
                                               lname: self.names!.1,
                                               username: self.names!.2,
                                               id: user!.uid)
                    self.displayAlert("Success!", "New user with username \(self.emailTextField.text!) created. Welcome to Pear!", [""], true)
                }
            }
        } else {
            self.displayAlert("Could not create new user", "Please fix the following errors:", errors, false)
        }
    }
    
    func saveNewPearUser(_ user: User) {
        let uid = user.uid
        let newUserRef = databaseRef.child("users").child(uid)
        newUserRef.setValue(["name-first": names!.0,
                             "name-last": names!.1,
                             "username": names!.2,
                             "id": uid])
        
    }
    
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
            errors.append("\n- Password and confirm password are not identical")
        }
        
        return errors
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostRegistrationSegue" {
            let controller = segue.destination as! PostRegistrationViewController
            controller.databaseRef = self.databaseRef
            controller.activeUser = self.activeUser
        }
    }
}
