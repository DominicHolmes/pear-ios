//
//  AccountNetworking.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import Alamofire

class AccountNetworkingManager {
    
    // Shared instance
    static let shared = AccountNetworkingManager()
    
    // Default network config
    let encoding: ParameterEncoding = JSONEncoding.default
    let headers: HTTPHeaders? = ["Content-Type": "application/json"]
    
    // Session manager
    private let sessionManager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: CustomServerTrustPoliceManager()
    )
    
    // MARK: - Create Account
    func createAccount(from createAccount: AccountCreate, _ completion: @escaping (_ success: Bool, _ account: Account?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = createAccount.dictionary
        
        sessionManager.request("https://35.231.241.240/account/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AccountHTTPSResponse.self, from: response.data!)
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
    
    // MARK: - Fetch Account
    func fetchAccount(for userId: UserId, with accountId: AccountId, _ completion: @escaping (_ success: Bool, _ account: Account?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "accountId": accountId]
        
        sessionManager.request("https://35.231.241.240/account/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AccountHTTPSResponse.self, from: response.data!)
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
    
    // MARK: - Fetch All Accounts
    func fetchAllAccounts(for userId: UserId, _ completion: @escaping (_ success: Bool, _ accounts: [Account]?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId]
        
        sessionManager.request("https://35.231.241.240/account/read/all", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AllAccountsHTTPSResponse.self, from: response.data!)
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
    
    // MARK: - Update Account
    func updateAccount(from accountUpdate: AccountUpdate, _ completion: @escaping (_ success: Bool, _ account: Account?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = accountUpdate.dictionary
        
        sessionManager.request("https://35.231.241.240/account/update", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AccountHTTPSResponse.self, from: response.data!)
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
    
    // MARK: - Delete Account
    func deleteAccount(for userId: UserId, with accountId: AccountId, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "accountId": accountId]
        
        sessionManager.request("https://35.231.241.240/account/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AccountHTTPSResponse.self, from: response.data!)
                completion(decodedResponse.status)
            }
            catch {
                print("ERROR - Could not delete account")
                completion(false)
            }
        }
    }
}
