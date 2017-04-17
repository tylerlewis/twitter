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
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: Config.twitterConsumerKey, consumerSecret: Config.twitterConsumerSecret)!
    
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
            
            self.getUserAccount(success: {
                (user: User) -> () in
                user.justLoggedIn = true
                self.loginSuccessHandler?()
            }, failure: {
                (error: Error?) -> () in
                print("ERROR")
                self.loginFailureHandler?(error!)
            })
            
        }, failure: { (error: Error?) in
            print("ERROR: \(error)")
            self.loginFailureHandler?(error!)
        })
    }
    
    func logout() {
        deauthorize()
        User.currentUser = nil
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
    }
    
    func getUserAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userResponse = response as! NSDictionary
            let user = User(user: userResponse)
            User.currentUser = user
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("ERROR")
            failure(error)
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let responseTweets = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(responseTweets: responseTweets)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("ERROR")
            print(error.localizedDescription)
            failure(error)
        })
    }
    
    func sendTweet(text: String!, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var parameters = [String: String]()
        parameters["status"] = text
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let createdTweet = response as! NSDictionary
            let tweet = Tweet(tweet: createdTweet)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print("ERROR SENDING TWEET")
            print(error.localizedDescription)
            failure(error)
        }
    }
    
    func retweet(tweet: Tweet, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(tweet.tweetId!).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("FAILED TO RETWEET")
        }
    }
    
    func favorite(tweet: Tweet, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        var parameters = [String: String]()
        parameters["id"] = tweet.tweetId
        post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("FAILED TO FAVORITE")
        }
    }
    
    func reply(tweet: Tweet, text: String!, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        var parameters = [String: String]()
        parameters["status"] = text
        parameters["in_reply_to_status_id"] = tweet.tweetId!
        post("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let createdTweet = response as! NSDictionary
            let tweet = Tweet(tweet: createdTweet)
            
            success(tweet)
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            print("FAILED TO REPLY")
        }
    }
}
