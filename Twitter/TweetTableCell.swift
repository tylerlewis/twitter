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
    @IBOutlet weak var replyIconButton: UIButton!
    @IBOutlet weak var retweetIconButton: UIButton!
    @IBOutlet weak var favoriteIconButton: UIButton!
    
    var originalTweet: Tweet!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 3.0
        let profileImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onProfileImageTap(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageViewTapGestureRecognizer)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        // Duplicated code with tweet detail view, refactor
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialize(tweet: Tweet) {
        if let profileImageUrl = tweet.user?.profileImageUrl {
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
        
        originalTweet = tweet
    }
    
    func onProfileImageTap(tapGestureRecognizer: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: Navigation.profileImageTappedNotification, object: nil, userInfo: originalTweet.user?.originalUserDictionary as! [AnyHashable : Any]?)
    }

}
