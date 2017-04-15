//
//  Use.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/14/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var username: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    
    init(user: NSDictionary) {
        name = user["name"] as? String
        username = user["screen_name"] as? String
        let profileImageUrlString = user["profile_image_url_https"] as? String
        if let profileImageUrlString = profileImageUrlString {
            profileImageUrl = NSURL(string: profileImageUrlString)
        }
        tagline = user["description"] as? String
    }

}
