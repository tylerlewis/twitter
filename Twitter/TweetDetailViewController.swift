//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/16/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = tweet.user, let profileImageUrl = user.profileImageUrl {
            profileImageView.setImageWith(profileImageUrl)
        }
        nameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.username
        tweetTextLabel.text = tweet.text
        
        if let timestamp = tweet.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            timestampLabel.text = dateFormatter.string(from: timestamp)
        }
        
        retweetCountLabel.text = tweet.retweetCount?.description
        favoriteCountLabel.text = tweet.favoriteCount?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyTap(_ sender: Any) {
        
    }
    
    @IBAction func onRetweetTap(_ sender: Any) {
        TwitterClient.sharedInstance.retweet(tweet: tweet, success: {
            
        }) { (error: Error) in
            
        }
    }
    
    @IBAction func onFavoriteTap(_ sender: Any) {
        TwitterClient.sharedInstance.favorite(tweet: tweet, success: {
            
        }) { (error: Error) in
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
