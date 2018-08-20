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
    
    enum LoginState {
        case none
        case auth
        case failedAuth
        case loadingUserInfo
        case loadingUserProfiles
    }
    
    var state: LoginState = .none {
        didSet {
            switch state {
            case .none: stopLoading()
            case .failedAuth: stopLoading()
            default: startLoading()
            }
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Logout if Firebase User if logged in
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
        }
    }

}

// MARK: - Login Methods
extension LoginViewController {
    
    func attemptLogin() {
        if emailTextField.hasText && passwordTextField.hasText {
            state = .auth
            Auth.auth().signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
                                if let error = error {
                                    
                                    self.state = .failedAuth
                                    
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
                                    } else {
                                        self.state = .failedAuth
                                    }
                                }
            }
        } else {
            displayAlert(with: ["Please enter your email and password"])
        }
    }
    
    func proceedWithLogin(_ user: PryntUser) {
        self.state = .none
        performSegue(withIdentifier: "LoginCompletedSegue", sender: user)
    }
}

// MARK: - Load Prynt User
extension LoginViewController {
    // Load user and challenges (after login verfified)
    
    func attemptLoadUser(with id: String) {
        self.state = .loadingUserInfo
        UserNetworkingManager.shared.fetchUser(for: id) { (success, user) in
            if success, let user = user {
                let user = PryntUser(from: user)
                self.fetchSocialProfiles(with: user)
                self.proceedWithLogin(user)
            } else {
                self.state = .none
                self.displayAlert(with: ["Sorry, we couldn't fetch your data. Please try again later."])
            }
        }
    }
    
    func fetchSocialProfiles(with user: PryntUser) {
        user.requestAllProfiles()
    }
}

// MARK: - Segue Control
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginCompletedSegue", let sender = sender as? PryntUser {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PryntTabBarController
            tabBarController.user = sender
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
