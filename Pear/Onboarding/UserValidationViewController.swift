//
//  UserValidationViewController.swift
//  Pear
//
//  Created by dominic on 5/26/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserValidationViewController: PearViewController {
    
    var authenticatedFIRUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize firebase database
        databaseRef = Database.database().reference()
        
        attemptLogin()
        
        /*// Logout if necessary
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch _ as NSError {
        }*/
    }
    
    func invalidUserToken() {
        performSegue(withIdentifier: "userNotLoggedIn", sender: nil)
    }
    
    func attemptLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.authenticatedFIRUser = user
                self.attemptLoadUser(with: user.uid)
            } else {
                self.invalidUserToken()
            }
        }
    }
    
    func proceedWithLogin() {
        if let _ = activeUser {
            performSegue(withIdentifier: "userLoggedInSegue", sender: nil)
        } else {
            invalidUserToken()
        }
    }
    
    // Load user and challenges (after login verfified)
    
    func attemptLoadUser(with id: String) {
        let userRef = self.databaseRef.child("users").child(id)
        userRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                if let userDict = snapshot.value as? Dictionary<String, String> {
                    self.activeUser = PearUser.init(of: userDict)
                    self.attemptLoadUsersSocialProfiles(with: self.activeUser!.id)
                } else {
                    self.activeUser = nil
                    self.invalidUserToken()
                }
            } else {
                self.activeUser = nil
                self.invalidUserToken()
            }
        })
    }
    
    func attemptLoadUsersSocialProfiles(with id: String) {
        let profilesRef = self.databaseRef.child("usersSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                guard let dict = snapshot.value as? Dictionary<String, Dictionary<String, String>> else { return }
                self.loadUsersSocialProfiles(withDict: dict)
            }
            self.proceedWithLogin()
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
    
    // Segue control
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userLoggedInSegue" {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PearTabBarController
            tabBarController.databaseRef = self.databaseRef
            tabBarController.activeUser = self.activeUser
        }
    }
    
}
