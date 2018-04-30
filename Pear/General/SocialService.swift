//
//  SocialService.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

enum SocialServiceType : String {
    
    case Behance
    case Dribble
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
    case GooglePlus
    case GroupMe
    case Medium
    case PhoneNumber
    case Pintrest
    case Reddit
    case Skype
    case Soundcloud
    case Tumblr
    case Venmo
    case Vsco
    
    
    static let allValues = [Behance, Dribble, Facebook, Twitter, Instagram,
                            YouTube, AdobeCloud, LinkedIn, Snapchat, Email,
                            WhatsApp, Spotify, Duolingo, GooglePlus, GroupMe,
                            Medium, PhoneNumber, Pintrest, Reddit, Skype,
                            Soundcloud, Tumblr, Venmo, Vsco]
    
    var photoName : String {
        switch self {
        case .Behance:       return "behance.png"
        case .Dribble:       return "dribble.png"
        case .Facebook:      return "facebook.png"
        case .Twitter:       return "twitter.png"
        case .Instagram:     return "instagram.png"
        case .YouTube:       return "youTube.png"
        case .AdobeCloud:    return "adobeCloud.png"
        case .LinkedIn:      return "linkedIn.png"
        case .Snapchat:      return "snapchat.png"
        case .Email:         return "email.png"
        case .WhatsApp:      return "whatsApp.png"
        case .Spotify:       return "spotify.png"
        case .Duolingo:      return "duolingo.png"
        case .GooglePlus:    return "googlePlus.png"
        case .GroupMe:       return "groupMe.png"
        case .Medium:        return "medium.png"
        case .PhoneNumber:   return "phoneNumber.png"
        case .Pintrest:      return "pintrest.png"
        case .Reddit:        return "reddit.png"
        case .Skype:         return "skype.png"
        case .Soundcloud:    return "soundcloud.png"
        case .Tumblr:        return "tumblr.png"
        case .Venmo:         return "venmo.png"
        case .Vsco:          return "vsco.png"
        }
    }
    
    var serviceName : String {
        switch self {
        case .AdobeCloud:  return "Adobe Cloud"
        case .GooglePlus:  return "Google Plus"
        case .PhoneNumber: return "Phone Number"
        default:           return self.rawValue
        }
    }
    
    var appURL : String {
        switch self {
        default: return "\(self.rawValue.lowercased)://user?username="
        }
    }
    
    var webURL : String {
        switch self {
        default: return "https://\(self.rawValue.lowercased).com/"
        }
    }
}

struct SocialService {
    var socialService: SocialServiceType!
    var handle: String!
    var ranking: Int?
}
