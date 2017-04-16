//
//  Use.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/14/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    
    var name: String?
    var username: String?
    var profileImageUrl: URL?
    var tagline: String?
    
    var originalUserDictionary: NSDictionary!
    
    init(user: NSDictionary) {
        name = user["name"] as? String
        username = user["screen_name"] as? String
        let profileImageUrlString = user["profile_image_url_https"] as? String
        if let profileImageUrlString = profileImageUrlString {
            profileImageUrl = URL(string: profileImageUrlString)
        }
        tagline = user["description"] as? String
        
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
