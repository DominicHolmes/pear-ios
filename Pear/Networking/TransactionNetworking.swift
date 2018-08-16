//
//  TransactionNetworking.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/15/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import Alamofire

class TransactionNetworkingManager {
    
    // Shared instance
    static let shared = TransactionNetworkingManager()
    
    // Default network config
    let encoding: ParameterEncoding = JSONEncoding.default
    let headers: HTTPHeaders? = ["Content-Type": "application/json"]
    
    // Session manager
    private let sessionManager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: CustomServerTrustPoliceManager()
    )
    
    // MARK: - Create Transaction
    func createTransaction(from createTransaction: TransactionCreate, _ completion: @escaping (_ success: Bool, _ account: Transaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = createTransaction.dictionary
        
        sessionManager.request("https://35.231.241.240/account/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let account = decodedResponse.account {
                    completion(true, account)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print(error)
                print("ERROR - Could not create account")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch Transaction
    func fetchTransaction(for userId: UserId, with accountId: TransactionId, _ completion: @escaping (_ success: Bool, _ account: Transaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "accountId": accountId]
        
        sessionManager.request("https://35.231.241.240/account/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let account = decodedResponse.account {
                    completion(true, account)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch account")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch All Transactions
    func fetchAllTransactions(for userId: UserId, _ completion: @escaping (_ success: Bool, _ accounts: [Transaction]?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId]
        
        sessionManager.request("https://35.231.241.240/account/read/all", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AllTransactionsHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let accounts = decodedResponse.accounts {
                    completion(true, accounts)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch all accounts")
                completion(false, nil)
                print(error)
            }
        }
    }
    
    // MARK: - Update Transaction
    func updateTransaction(from accountUpdate: TransactionUpdate, _ completion: @escaping (_ success: Bool, _ account: Transaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = accountUpdate.dictionary
        
        sessionManager.request("https://35.231.241.240/account/update", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let account = decodedResponse.account {
                    completion(true, account)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print(error)
                print("ERROR - Could not update account")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Delete Transaction
    func deleteTransaction(for userId: UserId, with accountId: TransactionId, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "accountId": accountId]
        
        sessionManager.request("https://35.231.241.240/account/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                completion(decodedResponse.status)
            }
            catch {
                print("ERROR - Could not delete account")
                completion(false)
            }
        }
    }
}
