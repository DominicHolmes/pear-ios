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
    func createProfile(from createProfile: PryntProfileCreate, _ completion: @escaping (_ success: Bool, _ profile: PryntProfile?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = createProfile.dictionary
        
        sessionManager.request("https://35.231.241.240/profile/create", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(PryntProfileHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let profile = decodedResponse.profile {
                    completion(true, profile)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not create profile")
                print(error)
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch Profile
    func fetchProfile(for userId: UserId, with profileId: ProfileId, _ completion: @escaping (_ success: Bool, _ profile: PryntProfile?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "profileId": profileId]
        
        sessionManager.request("https://35.231.241.240/profile/read", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(PryntProfileHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let profile = decodedResponse.profile {
                    completion(true, profile)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch profile")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Fetch All Profiles
    func fetchAllProfiles(for userId: UserId, _ completion: @escaping (_ success: Bool, _ profiles: [PryntProfile]?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId]
        
        sessionManager.request("https://35.231.241.240/profile/read/all", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(AllPryntProfilesHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let profiles = decodedResponse.profiles {
                    completion(true, profiles)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not fetch all profiles")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Update Profile
    func updateProfile(from profileInfo: PryntProfileUpdate, _ completion: @escaping (_ success: Bool, _ profile: PryntProfile?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = profileInfo.dictionary
        
        sessionManager.request("https://35.231.241.240/profile/update", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(PryntProfileHTTPSResponse.self, from: response.data!)
                if decodedResponse.status, let profile = decodedResponse.profile {
                    completion(true, profile)
                } else {
                    completion(false, nil)
                }
            }
            catch {
                print("ERROR - Could not update profile")
                completion(false, nil)
            }
        }
    }
    
    // MARK: - Delete Profile
    func deleteProfile(for userId: UserId, with profileId: ProfileId, _ completion: @escaping (_ success: Bool) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": userId, "profileId": profileId]
        
        sessionManager.request("https://35.231.241.240/profile/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).response { response in
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedResponse =  try jsonDecoder.decode(PryntProfileHTTPSResponse.self, from: response.data!)
                completion(decodedResponse.status)
            }
            catch {
                print("ERROR - Could not delete profile")
                completion(false)
            }
        }
    }
}
