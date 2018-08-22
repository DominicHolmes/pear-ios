//
//  PryntUser.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class PryntUser {
    
    var firstName: String!
    var lastName: String!
    var username: String!
    let id: String!
    var profiles: [PryntProfile]?
    var accounts: [Account]?
    var transactions: [Transaction]?
    
    init(firstName: String, lastName: String, username: String, id: String, profiles: [PryntProfile]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.id = id
        self.profiles = profiles
    }
    
    init(from userInfo: UserInfo) {
        self.firstName = userInfo.nameFirst
        self.lastName = userInfo.nameLast
        self.id = userInfo.id
        self.username = userInfo.username
    }
}

// MARK: - Profiles Networking
extension PryntUser {
    func requestAllProfiles() {
        ProfileNetworkingManager.shared.fetchAllProfiles(for: self.id) { (success, profiles) in
            if success, let profiles = profiles {
                self.profiles = profiles
            } else {
                dump(profiles)
            }
        }
    }
}

// MARK: - Profiles
extension PryntUser {
    
    func add(_ profile: PryntProfile) {
        // Replace a profile if the id already exists; append if it doesn't
        if profiles == nil { profiles = [PryntProfile]() }
        if let replacedProfile = profiles!.index(where: { (p) -> Bool in
            return profile.id == p.id
        }) {
            profiles![replacedProfile] = profile
        } else {
            profiles!.append(profile)
        }
    }
    
    func remove(profile profileId: ProfileId) {
        if profiles != nil, let index = profiles!.index(where: { $0.id == profileId }) {
            profiles!.remove(at: index)
        }
    }
}

// MARK: - Accounts
extension PryntUser {
    
    func add(_ account: Account) {
        // Replace an account if the id already exists; append if it doesn't
        if accounts == nil { accounts = [Account]() }
        if let replacedAccount = accounts!.index(where: { (acct) -> Bool in
            return account.id == acct.id
        }) {
            accounts![replacedAccount] = account
        } else {
            accounts!.append(account)
        }
    }
    
    func remove(account accountId: AccountId) {
        if accounts != nil, let index = accounts!.index(where: { $0.id == accountId }) {
            accounts!.remove(at: index)
        }
    }
}

// MARK: - Transactions
extension PryntUser {
    
    func add(_ transaction: Transaction) {
        // Replace an transaction if the id already exists; append if it doesn't
        if transactions == nil { transactions = [Transaction]() }
        if let replacedTransaction = transactions!.index(where: { (acct) -> Bool in
            return transaction.transaction.id == acct.transaction.id
        }) {
            transactions![replacedTransaction] = transaction
        } else {
            transactions!.append(transaction)
        }
    }
    
    func remove(transaction transactionId: TransactionId) {
        if transactions != nil, let index = transactions!.index(where: { $0.transaction.id == transactionId }) {
            transactions!.remove(at: index)
        }
    }
}

// MARK: - Filtered Transactions
extension PryntUser {
    
    func requests() -> [Transaction]? {
        guard let transactions = transactions else { return nil }
        return transactions.filter({ (t) -> Bool in
            t.transaction.state == .PENDING
        })
    }
    
    func requestsCount() -> Int? {
        guard let transactions = transactions else { return nil }
        return transactions.filter({ (t) -> Bool in
            t.transaction.state == .PENDING
        }).count
    }
    
    func contacts() -> [Transaction]? {
        guard let transactions = transactions else { return nil }
        return transactions.filter({ (t) -> Bool in
            t.transaction.state == .COMPLETE
        })
    }
    
    func contactsCount() -> Int? {
        guard let transactions = transactions else { return nil }
        return transactions.filter({ (t) -> Bool in
            t.transaction.state == .COMPLETE
        }).count
    }
}
