//
//  Tweet.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/14/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var favoriteCount: Int?
    var retweetCount: Int?
    
    init(tweet: NSDictionary) {
        text = tweet["text"] as? String
        
        let timestampString = tweet["created_at"] as? String
        if let timestampString = timestampString {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = dateFormatter.date(from: timestampString)
        }
        
        favoriteCount = (tweet["favourites_count"] as? Int) ?? 0
        retweetCount = (tweet["retweet_count"] as? Int) ?? 0
    }
    
    class func tweetsWithArray(responseTweets: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for responseTweet in responseTweets {
            let tweet = Tweet(tweet: responseTweet)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
