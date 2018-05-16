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

class LoginViewController: PearViewController {
    
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
    
    func startLoading() {
        spinner.startAnimating()
        loginButton.setTitle("", for: .normal)
    }
    
    func stopLoading() {
        spinner.stopAnimating()
        loginButton.setTitle("Login", for: .normal)
    }
    
    func displayAlert(with errors: [String]) {
        var message = ""
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: "Unable to Login",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
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
                self.loadUsersSocialProfiles(withSnapshot: snapshot)
            }
            self.performSegue(withIdentifier: "LoginCompletionSegue", sender: nil)
        })
    }
    
    func loadUsersSocialProfiles(withSnapshot snapshot: DataSnapshot){
        var loadedSocialProfiles = [SocialProfile]()
        if let profilesDict = snapshot.value as? [String: Any] {
            for eachProfileId in profilesDict.keys {
                if let eachProfile = profilesDict[eachProfileId] as? [String : String] {
                    var loadedServices = [SocialService]()
                    var profileName = "Profile"
                    let profileId = eachProfileId
                    for service in eachProfile {
                        if service.key == "!ProfileName" {
                            profileName = service.value
                        } else if service.key != "!ProfileId" {
                            let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                           handle: SocialProfile.parseHandle(service.value),
                                                           ranking: SocialProfile.parseRanking(service.value))
                            loadedServices.append(newService)
                        }
                    }
                    let newProfile = SocialProfile(name: profileName, services: loadedServices)
                    newProfile.setProfileID(id: profileId)
                    loadedSocialProfiles.append(newProfile)
                }
            }
        }
        activeUser?.profiles = loadedSocialProfiles
    }
    
    // Segue control
    
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
