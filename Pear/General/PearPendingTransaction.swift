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
    private var secondaryApproved: Bool = false
    private var secondaryDenied: Bool = false
    
    init(transactionID: String, secondaryProfileID: String) {
        self.transactionID = transactionID
        self.secondaryProfileID = secondaryProfileID
    }
    
}

extension PearPendingTransaction {
    
    func getFirebaseEncoding() -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        dict["transactionID"] = transactionID
        dict["secondaryApproved"] = secondaryApproved.description
        dict["secondaryDenied"] = secondaryDenied.description
        
        return dict
    }
}
