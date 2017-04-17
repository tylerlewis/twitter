//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/16/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking
import FontAwesome_swift

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyIconButton: UIButton!
    @IBOutlet weak var retweetIconButton: UIButton!
    @IBOutlet weak var favoriteIconButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = 3.0
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        retweetCountLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        favoriteCountLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        let replyIconString = String.fontAwesomeIcon(name: .reply)
        let replyIconAttributed = NSMutableAttributedString(string: replyIconString)
        replyIconAttributed.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 13), range: NSRange(location: 0,length: 1))
        replyIconButton.setAttributedTitle(replyIconAttributed, for: .normal)
        replyIconButton.titleLabel?.textColor = UIColor.lightGray
            
        let retweetIconString = String.fontAwesomeIcon(name: .retweet)
        let retweetIconAttributed = NSMutableAttributedString(string: retweetIconString)
        retweetIconAttributed.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 13), range: NSRange(location: 0,length: 1))
        retweetIconButton.setAttributedTitle(retweetIconAttributed, for: .normal)
        retweetIconButton.titleLabel?.textColor = UIColor.lightGray
        
        let favoriteIconString = String.fontAwesomeIcon(name: .starO)
        let favoriteIconAttributed = NSMutableAttributedString(string: favoriteIconString)
        favoriteIconAttributed.addAttribute(NSFontAttributeName, value: UIFont.fontAwesome(ofSize: 13), range: NSRange(location: 0,length: 1))
        favoriteIconButton.setAttributedTitle(favoriteIconAttributed, for: .normal)
        favoriteIconButton.titleLabel?.textColor = UIColor.lightGray

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

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyToTweet" {
            let composeTweetViewController = segue.destination as! ComposeTweetViewController
            composeTweetViewController.replyingToTweet = tweet
        }
    }

}
