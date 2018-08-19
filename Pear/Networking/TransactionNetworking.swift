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
    func createTransaction(from createTransaction: TransactionCreate, _ completion: @escaping (_ success: Bool, _ transaction: Transaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = createTransaction.dictionary
        
        sessionManager.request("https://35.231.241.240/transaction/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let transaction = decodedResponse.transaction {
                    completion(true, transaction)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print(error)
                print("ERROR - Could not create transaction")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Accept Transaction
    func acceptTransaction(from acceptTransaction: TransactionAccept, _ completion: @escaping (_ success: Bool, _ transaction: FinishedTransaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = acceptTransaction.dictionary
        
        sessionManager.request("https://35.231.241.240/transaction/complete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let transaction = decodedResponse.transaction, let primaryProfile = decodedResponse.primaryProfile {
                    let finishedTransaction = FinishedTransaction(transaction: transaction,
                                                                  primaryProfile: primaryProfile,
                                                                  secondaryProfile: decodedResponse.secondaryProfile)
                    completion(true, finishedTransaction)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print(error)
                print("ERROR - Could not complete transaction")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Reciprocate Transaction
    func reciprocateTransaction(from reciprocateTransaction: TransactionReciprocate, _ completion: @escaping (_ success: Bool, _ transaction: FinishedTransaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = reciprocateTransaction.dictionary
        
        sessionManager.request("https://35.231.241.240/transaction/complete/profile", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let transaction = decodedResponse.transaction, let primaryProfile = decodedResponse.primaryProfile {
                    let finishedTransaction = FinishedTransaction(transaction: transaction,
                                                                  primaryProfile: primaryProfile,
                                                                  secondaryProfile: decodedResponse.secondaryProfile)
                    completion(true, finishedTransaction)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print(error)
                print("ERROR - Could not reciprocate transaction")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch Transaction
    func fetchTransaction(for userId: UserId, with transactionId: TransactionId, _ completion: @escaping (_ success: Bool, _ transaction: FinishedTransaction?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "transactionId": transactionId]
        
        sessionManager.request("https://35.231.241.240/transaction/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let transaction = decodedResponse.transaction, let primaryProfile = decodedResponse.primaryProfile {
                    let finishedTransaction = FinishedTransaction(transaction: transaction,
                                                                  primaryProfile: primaryProfile,
                                                                  secondaryProfile: decodedResponse.secondaryProfile)
                    completion(true, finishedTransaction)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch transaction")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch All Transactions
    func fetchAllTransactions(for userId: UserId, _ completion: @escaping (_ success: Bool, _ transactions: [FinishedTransaction]?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId]
        
        sessionManager.request("https://35.231.241.240/transactions/read/all", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AllTransactionsHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let transactions = decodedResponse.transactions {
                    completion(true, transactions)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch all transactions")
                completion(false, nil)
                print(error)
            }
        }
    }
    
    // MARK: - Delete Transaction
    func deleteTransaction(for userId: UserId, with transactionId: TransactionId, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "transactionId": transactionId]
        
        sessionManager.request("https://35.231.241.240/transaction/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(TransactionHTTPSResponse.self, from: response.data!)
                completion(decodedResponse.status)
            }
            catch {
                print("ERROR - Could not delete transaction")
                completion(false)
            }
        }
    }
}
