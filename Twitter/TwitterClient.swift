//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/12/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "LjToZj7xpxv75p202ePQcs3E0", consumerSecret: "1SM5sn1hsCmri9UXSqtYsI6C6Dfe6Tul0iDoxoQcSOjeeI0DyI")!
    
    var loginSuccessHandler: (() -> ())?
    var loginFailureHandler: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccessHandler = success
        loginFailureHandler = failure
        
        deauthorize()

        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as! URL, scope: nil, success: { (requestToken:BDBOAuth1Credential?) in
            
            let token = (requestToken?.token!)!
            print(token)
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            UIApplication.shared.openURL(url as URL)
            
        }, failure: { (error: Error?) in
            print("ERROR \(error?.localizedDescription)")
            self.loginFailureHandler?(error!)
        })
    }
    
    func completeLogin(url: URL, success: () -> (), failure: (Error) -> ()) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.loginSuccessHandler?()
            
            self.getUserAccount(success: {
                (user: User) -> () in
                print(user)
            }, failure: {
                (error: Error) -> () in
                print("ERROR")
            })
            
            self.getHomeTimeline(success: {
                (tweets: [Tweet]) -> () in
                for tweet in tweets {
                    print("\(tweet.text!)")
                }
            }, failure: {
                (error: Error) -> () in
                print("ERROR")
            })
            
        }, failure: { (error: Error?) in
            print("ERROR: \(error)")
            self.loginFailureHandler?(error!)
        })
    }
    
    func getUserAccount(success: @escaping (User) -> (), failure: (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userResponse = response as! NSDictionary
            let user = User(user: userResponse)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("ERROR")
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let responseTweets = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(responseTweets: responseTweets)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("ERROR")
        })
    }
}
