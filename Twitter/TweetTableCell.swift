//
//  TweetTableCell.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
