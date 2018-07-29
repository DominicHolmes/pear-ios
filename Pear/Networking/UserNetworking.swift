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
    
    static let shared = UserNetworkingManager()
    
    func createUser(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let parameters: Parameters? = userInfo.dictionary
        let method = Alamofire.HTTPMethod.post
        let encoding: ParameterEncoding = Alamofire.URLEncoding.httpBody
        let headers: HTTPHeaders? = ["Content-Type": "application/json"]
        
        Alamofire.request("35.231.241.240/user/create", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                completion(true, UserInfo(id: "nil", username: "nil", nameFirst: "nil", nameLast: "nil"))
            } else {
                completion(false, nil)
            }
        }
    }
    
    func fetchUser(for id: String, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        let encoding: ParameterEncoding = Alamofire.URLEncoding.httpBody
        let headers: HTTPHeaders? = ["Content-Type": "application/json"]

        Alamofire.request("https://35.231.241.240/user/read", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                completion(true, UserInfo(id: "nil", username: "nil", nameFirst: "nil", nameLast: "nil"))
            } else {
                completion(false, nil)
            }
        }
    }
    
    func updateUser(from userInfo: UserInfo, _ completion: @escaping (_ success: Bool, _ user: UserInfo?) -> Void) {
        
        // Including handle in this, even though handle cannot be updated
        let parameters: Parameters? = userInfo.dictionary
        let method = Alamofire.HTTPMethod.post
        let encoding: ParameterEncoding = Alamofire.URLEncoding.httpBody
        let headers: HTTPHeaders? = ["Content-Type": "application/json"]
        
        Alamofire.request("35.231.241.240/user/update", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                completion(true, UserInfo(id: "nil", username: "nil", nameFirst: "nil", nameLast: "nil"))
            } else {
                completion(false, nil)
            }
        }
    }
    
    func deleteUser(with id: String, _ completion: @escaping (_ success: Bool) -> Void) {
        
        // Including handle in this, even though handle cannot be updated
        let method = Alamofire.HTTPMethod.post
        let parameters: Parameters? = ["id": id]
        let encoding: ParameterEncoding = Alamofire.URLEncoding.httpBody
        let headers: HTTPHeaders? = ["Content-Type": "application/json"]
        
        Alamofire.request("35.231.241.240/user/delete", method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
