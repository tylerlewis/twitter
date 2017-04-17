//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking

protocol ComposeTweetDelegate: class {
    func composeTweet(composer: ComposeTweetViewController, didComposeTweet tweet: Tweet?)
}

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: ComposeTweetDelegate?
    
    var replyingToTweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userProfileImageView.layer.cornerRadius = 3.0

        nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        let currentUser = User.currentUser!
        userProfileImageView.setImageWith(currentUser.profileImageUrl!)
        nameLabel.text = currentUser.name
        usernameLabel.text = currentUser.username
        tweetTextView.text = ""
        
        if let replyingToTweet = replyingToTweet {
            tweetTextView.text = "@\((replyingToTweet.user?.username)!) "
        }
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        if let replyingToTweet = replyingToTweet {
            TwitterClient.sharedInstance.reply(tweet: replyingToTweet, text: tweetTextView.text, success: {
                
            }, failure: { (error: Error) in
                
            })
        } else {
            TwitterClient.sharedInstance.sendTweet(text: tweetTextView.text, success: { (tweet: Tweet) in
                
                self.delegate?.composeTweet(composer: self, didComposeTweet: tweet)
                
            }) { (error: Error) in
                
            }
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
