//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/22/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var isCurrentUser: Bool = true
    var user: User!
    var tweets: [Tweet]! = [Tweet]()
    var isLoadingTweets: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the let bar button item, depending on if logged-in user or viewing other user
        if Profile.isCurrentUser! {
           navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToHomeTimeline))
        }
        let leftBarButtonTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)
        ]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftBarButtonTextAttributes, for: .normal)
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.separatorInset = UIEdgeInsets.zero
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 100
        
        profileImageView.layer.cornerRadius = 3.0
        
        backgroundImageView.image = UIImage(named: "twitter_cloud")
        
        // Set up user-specific properties
        user = Profile.user
        
        self.title = user.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        profileImageView.setImageWith(user.profileImageUrl!)
        
        nameLabel.text = user.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        usernameLabel.text = user.username
        
        tweetCountLabel.text = user.tweetCount?.description
        tweetCountLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        followingCountLabel.text = user.followingCount?.description
        followingCountLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        followerCountLabel.text = user.followerCount?.description
        followerCountLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        
        // Fetch tweets
        // TODO - Cache tweets from initial call, for profile at least
        isLoadingTweets = true
        TwitterClient.sharedInstance.getUserTimeline(username: user.username!, success: { (tweets:[Tweet]) in
            self.loadTweets(tweets: tweets)
        }) { (Error) in
            self.isLoadingTweets = false

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetTableCellInProfile") as! TweetTableCell
        let tweet = tweets[indexPath.row]
        cell.initialize(tweet: tweet)
        return cell
    }
    
    func loadTweets(tweets: [Tweet]) {
        self.isLoadingTweets = false
        self.tweets = tweets
        self.tweetsTableView.reloadData()
    }
    
    func signOut() {
        TwitterClient.sharedInstance.logout()
    }
    
    func backToHomeTimeline() {
        NotificationCenter.default.post(name: Navigation.backToHomeTimelineNotification, object: nil)
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
