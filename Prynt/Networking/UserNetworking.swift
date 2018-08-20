//
//  UserNetworking.swift
//  Prynt
//
//  Created by Dominic Holmes on 7/28/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import Alamofire

class UserNetworkingManager {
    
    // Shared instance
    static let shared = UserNetworkingManager()
    
    // Default network config
    let encoding: ParameterEncoding = JSONEncoding.default
    let headers: HTTPHeaders? = ["Content-Type": "application/json"]
    
    // Session manager
    private let sessionManager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: CustomServerTrustPoliceManager()
    )
    
    // MARK: - Create User
    func createUser(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = userInfo.dictionary
        
        sessionManager.request("https://35.231.241.240/user/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(UserInfoHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let user = decodedResponse.user {
                    completion(true, user)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not create user")
            }
        }
    }
    
    // MARK: - Fetch User
    func fetchUser(for id: UserId, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        
        sessionManager.request("https://35.231.241.240/user/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(UserInfoHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let user = decodedResponse.user {
                    completion(true, user)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch user")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Update User
    func updateUser(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = userInfo.dictionary
        
        sessionManager.request("https://35.231.241.240/user/update", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(UserInfoHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let user = decodedResponse.user {
                    completion(true, user)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not update user")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Delete User
    func deleteUser(with id: UserId, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        
        sessionManager.request("https://35.231.241.240/user/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(UserInfoHTTPSResponse.self, from: response.data!)
                completion(decodedResponse.status)
            }
            catch {
                print("ERROR - Could not delete user")
                completion(false)
            }
        }
    }
    
    // MARK: - Clear Blockchain
    func clearBlockchain(_ completion: @escaping (_ success: Bool) -> Void) {
        var REMOVE_BEFORE_RELEASE__🛠🛠🛠: AnyObject
        let method = Alamofire.HTTPMethod.get
        
        struct ClearBlockchainResponse: Codable {
            let status: Bool?
        }
        
        // Users
        sessionManager.request("https://35.231.241.240/service/clear/user", method: method, parameters: nil, encoding: encoding, headers: headers).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(ClearBlockchainResponse.self, from: response.data!)
                if let status = decodedResponse.status {
                    completion(status)
                } else {
                    completion(false)
                }
            }
            catch {
                print("ERROR - Could not clear users")
            }
        }
        
        // Profiles
        sessionManager.request("https://35.231.241.240/service/clear/profile", method: method, parameters: nil, encoding: encoding, headers: headers).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(ClearBlockchainResponse.self, from: response.data!)
                if let status = decodedResponse.status {
                    completion(status)
                } else {
                    completion(false)
                }
            }
            catch {
                print("ERROR - Could not clear profiles")
            }
        }
        
        // Accounts
        sessionManager.request("https://35.231.241.240/service/clear/account", method: method, parameters: nil, encoding: encoding, headers: headers).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(ClearBlockchainResponse.self, from: response.data!)
                if let status = decodedResponse.status {
                    completion(status)
                } else {
                    completion(false)
                }
            }
            catch {
                print("ERROR - Could not clear accounts")
            }
        }
        
        // Transaction
        sessionManager.request("https://35.231.241.240/service/clear/transaction", method: method, parameters: nil, encoding: encoding, headers: headers).response { response in
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(ClearBlockchainResponse.self, from: response.data!)
                if let status = decodedResponse.status {
                    completion(status)
                } else {
                    completion(false)
                }
            }
            catch {
                print("ERROR - Could not clear transactions")
            }
        }
    }
}

class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}
