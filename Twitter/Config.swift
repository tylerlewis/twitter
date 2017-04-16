//
//  Config.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class Config: NSObject {
    
    class var twitterConsumerKey: String {
        get {
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
                if let keys = NSDictionary(contentsOfFile: path) {
                    print(keys["twitterConsumerKey"] as! String)
                    return keys["twitterConsumerKey"] as? String ?? ""
                }
                return ""
            }
            return ""
        }
    }
    
    class var twitterConsumerSecret: String {
        get {
            if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
                if let keys = NSDictionary(contentsOfFile: path) {
                    return keys["twitterConsumerSecret"] as? String ?? ""
                }
                return ""
            }
            return ""
        }
    }

}
