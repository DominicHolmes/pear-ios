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
        
        sessionManager.request("https://35.231.241.240:80/user/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
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
    func fetchUser(for id: String, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        
        sessionManager.request("https://35.231.241.240:80/user/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
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
        
        sessionManager.request("https://35.231.241.240:80/user/update", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
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
    func deleteUser(with id: String, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        
        sessionManager.request("https://35.231.241.240:80/user/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
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
}

class CustomServerTrustPoliceManager : ServerTrustPolicyManager {
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    public init() {
        super.init(policies: [:])
    }
}
