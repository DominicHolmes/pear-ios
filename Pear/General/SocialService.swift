//
//  SocialService.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

enum SocialServiceType : String {
    
    case Facebook
    case Twitter
    case Instagram
    case YouTube
    case AdobeCloud
    case LinkedIn
    case Snapchat
    case Email
    case WhatsApp
    case Spotify
    case Duolingo
    
    static let allValues = [Facebook, Twitter, Instagram, YouTube, AdobeCloud,
                            LinkedIn, Snapchat, Email, WhatsApp, Spotify,
                            Duolingo]
    
    var photoName : String {
        switch self {
        case .Facebook: return "facebook.png"
        case .Twitter:  return "twitter.png"
        default:        return "default.png"
        }
    }
    
    var serviceName : String {
        switch self {
        case .AdobeCloud: return "Adobe Cloud"
        default:          return self.rawValue
        }
    }
}

struct SocialService {
    var socialService: SocialServiceType!
    var handle: String!
}
