//
//  ViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/12/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogInTap(_ sender: Any) {
        
        TwitterClient.sharedInstance.login(success: { 
            print("I've logged in!")
            
            NotificationCenter.default.post(name: User.userDidLogInNotification, object: nil)
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (Error) in
            print("Didn't log in...")
        }
        
    }
    
}

