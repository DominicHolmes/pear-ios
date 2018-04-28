//
//  PearUser.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PearUser: NSObject {
    
    var firstName: String!
    var lastName: String!
    var username: String!
    let id: String!
    
    // User's list of social profiles
    var profiles = [String]()
    
    init(fname: String, lname: String, username: String, id: String) {
        self.firstName = fname
        self.lastName = lname
        self.username = username
        self.id = id
    }
    
    init(of dict: Dictionary<String, String>) {
        self.firstName = dict["name-first"]
        self.lastName = dict["name-last"]
        self.username = dict["username"]
        self.id = dict["id"]
    }
}

extension PearUser {
    func getProfiles(with ref: DatabaseReference) -> [SocialProfile]? {
        let userProfileRef = ref.child("userProfiles").child(self.id)
        
        userProfileRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                if let userProfiles = snapshot.value as? NSArray {
                    dump(userProfiles)
                }
            }
        })
        return nil
    }
}
