//
//  LoginViewController.swift
//  Pear
//
//  Created by dominic on 4/29/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: PearLoginViewController {
    
    var authenticatedFIRUser: User?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize firebase database
        databaseRef = Database.database().reference()
        
        // Logout if necessary
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
        }
    }
    
    func attemptLogin() {
        if emailTextField.hasText && passwordTextField.hasText {
            startLoading()
            Auth.auth().signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
                                if let error = error {
                                    self.stopLoading()
                                    let nsError = error as NSError
                                    switch AuthErrorCode(rawValue: nsError.code)! {
                                    case .operationNotAllowed:
                                        self.displayAlert(with: ["Account not enabled, please contact support"])
                                    case .invalidEmail:
                                        self.displayAlert(with: ["Please enter a valid email address"])
                                    case .userDisabled:
                                        self.displayAlert(with: ["Your account is disabled, please contact support"])
                                    case .wrongPassword:
                                        self.displayAlert(with: ["Incorrect password, please try again"])
                                    default:
                                        self.displayAlert(with: ["Unknown error, please try again"])
                                    }
                                }
                                _ = Auth.auth().addStateDidChangeListener { (auth, user) in
                                    self.authenticatedFIRUser = user
                                    if user != nil {
                                        self.attemptLoadUser(with: user!.uid)
                                    }
                                }
            }
        } else {
            displayAlert(with: ["Please enter your email and password"])
        }
    }
    
    func proceedWithLogin() {
        if let _ = activeUser {
            performSegue(withIdentifier: "LoginCompletedSegue", sender: nil)
        } else {
            stopLoading()
            displayAlert(with: ["Error logging in"])
        }
    }
    
    // Load user and challenges (after login verfified)
    
    func attemptLoadUser(with id: String) {
        let userRef = databaseRef.child("users").child(id)
        userRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                if let userDict = snapshot.value as? Dictionary<String, String> {
                    self.activeUser = PearUser.init(of: userDict)
                    self.attemptLoadUsersSocialProfiles(with: self.activeUser!.id)
                } else {
                    self.activeUser = nil
                }
            } else {
                self.activeUser = nil
            }
        })
    }
    
    func attemptLoadUsersSocialProfiles(with id: String) {
        let profilesRef = databaseRef.child("usersSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                if let dict = snapshot.value as? Dictionary<String, Dictionary<String, String>> {
                    self.loadUsersSocialProfiles(withDict: dict)
                }
            }
            self.performSegue(withIdentifier: "LoginCompletionSegue", sender: nil)
        })
    }
    
    func loadUsersSocialProfiles(withDict dict: Dictionary<String, Dictionary<String, String>>) {
        var loadedSocialProfiles = [SocialProfile]()
        for eachProfile in dict {
            let newProfile = SocialProfile(of: eachProfile.value)
            loadedSocialProfiles.append(newProfile)
        }
        activeUser?.profiles = loadedSocialProfiles
    }
}

// MARK: - Segue Control
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        stopLoading()
        if segue.identifier == "LoginCompletionSegue" {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PearTabBarController
            tabBarController.databaseRef = self.databaseRef
            tabBarController.activeUser = self.activeUser
        }
    }
}

// MARK: - IBActions
extension LoginViewController {
    @IBAction func privacyPolicyButtonPressed() {
        if let url = URL(string: "https://www.iubenda.com/privacy-policy/8203081") {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
            }
        }
    }
    @IBAction func emailFieldNextButtonPressed() {
        passwordTextField.becomeFirstResponder()
    }
    @IBAction func loginActionTriggered() {
        dismissKeyboard()
        attemptLogin()
    }
    @IBAction func textFieldValueValueChanged() {
        if emailTextField.hasText && passwordTextField.hasText {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    // Spinner
    fileprivate func startLoading() {
        spinner.startAnimating()
        loginButton.setTitle("", for: .normal)
    }
    fileprivate func stopLoading() {
        spinner.stopAnimating()
        loginButton.setTitle("Login", for: .normal)
    }
}
