//
//  AppDelegate.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/12/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if User.currentUser != nil {
            print("There is a user")
            // Take user on in to Tweets page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = window!.rootViewController as! MainViewController            
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuViewController.mainViewController = mainViewController
            mainViewController.menuViewController = menuViewController
        } else {
            print("There is no user")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginViewController
        }
        
        NotificationCenter.default.addObserver(forName: User.userDidLogInNotification, object: nil, queue: OperationQueue.main) { (Notification) in
            
            // Take user to tweets page, initialize container view
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuViewController.mainViewController = mainViewController
            mainViewController.menuViewController = menuViewController
            
            self.window?.rootViewController = mainViewController
        }
        
        NotificationCenter.default.addObserver(forName: User.userDidLogoutNotification, object: nil, queue: OperationQueue.main) { (Notification) in
            
            // Take user back to login page
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginViewController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        TwitterClient.sharedInstance.completeLogin(url: url, success: {
            print("Did complete login")
        }) { (Error) in
            print("Error in login completion")
        }
        
        return true
    }

}

