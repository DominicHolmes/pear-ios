//
//  ProfileNetworking.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/7/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import Alamofire

class ProfileNetworkingManager {
    
    // Shared instance
    static let shared = ProfileNetworkingManager()
    
    // Default network config
    let encoding: ParameterEncoding = JSONEncoding.default
    let headers: HTTPHeaders? = ["Content-Type": "application/json"]
    
    // Session manager
    private let sessionManager = Alamofire.SessionManager(
        configuration: URLSessionConfiguration.default,
        serverTrustPolicyManager: CustomServerTrustPoliceManager()
    )
    
    // MARK: - Create Profile
    func createProfile(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
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
    
    // MARK: - Fetch Profile
    func fetchProfile(for id: String, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
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
    
    // MARK: - Update Profile
    func updateProfile(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
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
    
    // MARK: - Delete Profile
    func deleteProfile(with id: String, _ completion: @escaping (_ success: Bool) -> Void) {
        
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
