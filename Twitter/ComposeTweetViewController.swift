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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentUser = User.currentUser!
        userProfileImageView.setImageWith(currentUser.profileImageUrl!)
        nameLabel.text = currentUser.name
        usernameLabel.text = currentUser.username
        tweetTextView.text = ""
        
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetTap(_ sender: Any) {
        TwitterClient.sharedInstance.sendTweet(text: tweetTextView.text, success: { (tweet: Tweet) in
            
            self.delegate?.composeTweet(composer: self, didComposeTweet: tweet)
            
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