//
//  TweetTableCell.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking
import FontAwesome_swift

class TweetTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyIconLabel: UILabel!
    @IBOutlet weak var retweetIconLabel: UILabel!
    @IBOutlet weak var favoriteIconLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3.0
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        replyIconLabel.font = UIFont.fontAwesome(ofSize: 13)
        replyIconLabel.text = String.fontAwesomeIcon(name: .reply)
        retweetIconLabel.font = UIFont.fontAwesome(ofSize: 13)
        retweetIconLabel.text = String.fontAwesomeIcon(name: .retweet)
        favoriteIconLabel.font = UIFont.fontAwesome(ofSize: 13)
        favoriteIconLabel.text = String.fontAwesomeIcon(name: .starO)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(tweet: Tweet) {
        if let user = tweet.user, let profileImageUrl = user.profileImageUrl {
            profileImageView.setImageWith(profileImageUrl)
        }
        nameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.username
        
        if let timestamp = tweet.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            timestampLabel.text = dateFormatter.string(from: timestamp)
        }
        
        tweetTextLabel.text = tweet.text
    }

}
