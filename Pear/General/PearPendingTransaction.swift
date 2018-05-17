//
//  PearPendingTransaction.swift
//  Pear
//
//  Created by dominic on 5/17/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class PearPendingTransaction {
    
    private var transactionID: String!
    private var secondaryProfileID: String!
    private var secondaryApproval: Bool = false
    
    init(transactionID: String, secondaryProfileID: String) {
        self.transactionID = transactionID
        self.secondaryProfileID = secondaryProfileID
    }
    
}

extension PearPendingTransaction {
    
    func getFirebaseEncoding() -> [String: String]! {
        var dict = Dictionary<String, String>()
        
        dict["transactionID"] = transactionID
        dict["secondaryApproval"] = secondaryApproval.description
        
        return dict
    }
}
