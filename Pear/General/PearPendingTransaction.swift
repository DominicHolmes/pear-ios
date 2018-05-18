//
//  PearPendingTransaction.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class PearPendingTransaction {
    
    let transactionID: String!
    let secondaryProfileID: String!
    let primaryProfileID: String?
    private var secondaryApproved: Bool = false
    private var secondaryDenied: Bool = false
    
    init(transactionID: String, secondaryProfileID: String, primaryProfileID: String?) {
        self.transactionID = transactionID
        self.secondaryProfileID = secondaryProfileID
        self.primaryProfileID = primaryProfileID
    }
    
    init(of dict: Dictionary<String, String>) {
        self.transactionID = dict["transactionID"]
        self.secondaryDenied = (dict["secondaryDenied"] == "true")
        self.secondaryApproved = (dict["secondaryApproved"] == "true")
        self.secondaryProfileID = dict["secondaryProfileID"]
        if dict["primaryProfileID"] == "!NONE" {
            self.primaryProfileID = nil
        } else {
            self.primaryProfileID = dict["primaryProfileID"]
        }
    }
    
}

extension PearPendingTransaction {
    
    func getFirebaseEncoding() -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        dict["transactionID"] = transactionID
        dict["secondaryApproved"] = secondaryApproved.description
        dict["secondaryDenied"] = secondaryDenied.description
        dict["secondaryProfileID"] = secondaryProfileID
        if primaryProfileID != nil {
            dict["primaryProfileID"] = primaryProfileID!
        } else {
            dict["primaryProfileID"] = "!NONE"
        }
        
        return dict
    }
    
    func isApproved() -> Bool {
        return secondaryApproved && !secondaryDenied
    }
    
    func isDenied() -> Bool {
        return secondaryDenied
    }
}
