//
//  Use.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/14/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogInNotification = NSNotification.Name(rawValue: "UserDidLogIn")
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    var name: String?
    var username: String?
    var profileImageUrl: URL?
    var tagline: String?
    var tweetCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    var justLoggedIn: Bool = false
    
    var originalUserDictionary: NSDictionary!
    
    init(user: NSDictionary) {
        print(user)
        name = user["name"] as? String
        
        let rawUsername = user["screen_name"] as? String
        username = "@\(rawUsername!)"
        
        let profileImageUrlString = user["profile_image_url_https"] as? String
        if let profileImageUrlString = profileImageUrlString {
            profileImageUrl = URL(string: profileImageUrlString)
        }
        tagline = user["description"] as? String
        tweetCount = user["statuses_count"] as? Int
        followingCount = user["friends_count"] as? Int
        followerCount = user["followers_count"] as? Int
        
        originalUserDictionary = user
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let userDefaults = UserDefaults.standard
                
                let userData = userDefaults.object(forKey: "currentUser") as? Data
                if let userData = userData {
                    let data = try! JSONSerialization.jsonObject(with: userData, options: [])
                    return User(user: data as! NSDictionary)
                }
                
                return nil
            }
            return _currentUser
        }
        set(user) {
            let userDefaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.originalUserDictionary, options: [])
                userDefaults.set(data, forKey: "currentUser")
            } else {
                userDefaults.removeObject(forKey: "currentUser")
            }
            
            _currentUser = user
            
            userDefaults.synchronize()
        }
    }

}
