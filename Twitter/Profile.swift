//
//  Profile.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/23/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class Profile: NSObject {
        
    static var _isCurrentUser: Bool!
    
    class var isCurrentUser: Bool! {
        get {
            return _isCurrentUser
        }
        set(isCurrentUser) {
            _isCurrentUser = isCurrentUser
        }
    }
    
    static var _user: User!
    
    class var user: User! {
        get {
            return _user
        }
        set(user) {
            _user = user
        }
    }

}
