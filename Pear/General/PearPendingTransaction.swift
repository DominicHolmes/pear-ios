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
    
    var transaction: PearTransaction? {
        didSet {
            self.primaryName = transaction?.primaryName
            self.primaryHandle = transaction?.primaryHandle
            self.primaryUsersName = transaction?.primaryUsersName
            self.secondaryName = transaction?.secondaryName
            self.secondaryHandle = transaction?.secondaryHandle
            self.secondaryUsersName = transaction?.secondaryUsersName
        }
    }
    
    var primaryName: String?
    var primaryHandle: String?
    var primaryUsersName: String?
    var secondaryName: String?
    var secondaryHandle: String?
    var secondaryUsersName: String?
    
    init(transactionID: String, secondaryProfileID: String, primaryProfileID: String?, transaction: PearTransaction?) {
        self.transactionID = transactionID
        self.secondaryProfileID = secondaryProfileID
        self.primaryProfileID = primaryProfileID
        self.transaction = transaction
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
        
        self.primaryName = dict["primaryName"]
        self.primaryHandle = dict["primaryHandle"]
        self.primaryUsersName = dict["primaryUsersName"]
        self.secondaryName = dict["secondaryName"]
        self.secondaryHandle = dict["secondaryHandle"]
        self.secondaryUsersName = dict["secondaryUsersName"]
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
        
        if let _ = primaryName { dict["primaryName"] = self.primaryName! }
        if let _ = primaryHandle { dict["primaryHandle"] = self.primaryHandle! }
        if let _ = primaryUsersName { dict["primaryUsersName"] = self.primaryUsersName! }
        if let _ = secondaryName { dict["secondaryName"] = self.secondaryName! }
        if let _ = secondaryHandle { dict["secondaryHandle"] = self.secondaryHandle! }
        if let _ = secondaryUsersName { dict["secondaryUsersName"] = self.secondaryUsersName! }
        
        return dict
    }
    
    func getFirebaseEncodingStub(from perspective: PearTransactionPerspective) -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        dict["transactionID"] = transactionID
        
        switch perspective {
        case .primary:      if let _ = secondaryName { dict["secondaryName"] = self.secondaryName! }
                            if let _ = secondaryHandle { dict["secondaryHandle"] = self.secondaryHandle! }
                            if let _ = secondaryUsersName { dict["secondaryUsersName"] = self.secondaryUsersName! }
        case .secondary:    if let _ = primaryName { dict["primaryName"] = self.primaryName! }
                            if let _ = primaryHandle { dict["primaryHandle"] = self.primaryHandle! }
                            if let _ = primaryUsersName { dict["primaryUsersName"] = self.primaryUsersName! }
        }
        
        return dict
    }
    
    func isApproved() -> Bool {
        return secondaryApproved && !secondaryDenied
    }
    
    func setApproval() {
        secondaryApproved = true
    }
    
    func isDenied() -> Bool {
        return secondaryDenied
    }
    
    func setDenial() {
        secondaryDenied = true
    }
}
