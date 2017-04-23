//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeTweetDelegate {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var isLoadingTweets: Bool = false
    var tweets: [Tweet] = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self

        tweetsTableView.separatorInset = UIEdgeInsets.zero
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 100
        
        let tweetsRefreshControl = UIRefreshControl()
        tweetsRefreshControl.addTarget(self, action: #selector(refreshTweetsControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(tweetsRefreshControl, at: 0)
        
        getTweets(success: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutTap(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetTableCell") as! TweetTableCell
        
        let tweet = tweets[indexPath.row]
        
        tweetCell.initialize(tweet: tweet)
        
        tweetCell.replyIconButton.tag = indexPath.row
        tweetCell.retweetIconButton.tag = indexPath.row
        tweetCell.favoriteIconButton.tag = indexPath.row
        
        return tweetCell
    }
    
    @IBAction func onRetweetTap(_ sender: Any) {
        if let retweetButton = sender as? UIButton {
            let selectedTweetIndex = retweetButton.tag
            let tweet = tweets[selectedTweetIndex]
            TwitterClient.sharedInstance.retweet(tweet: tweet, success: {
                
            }) { (error: Error) in
                
            }
        }
    }
    
    @IBAction func onFavoriteTap(_ sender: Any) {
        if let favoriteButton = sender as? UIButton {
            let selectedTweetIndex = favoriteButton.tag
            let tweet = tweets[selectedTweetIndex]
            TwitterClient.sharedInstance.favorite(tweet: tweet, success: {
                
            }) { (error: Error) in
                
            }
        }
    }
    
    func getTweets(success: (() -> ())?) {
        isLoadingTweets = true
        
        TwitterClient.sharedInstance.getHomeTimeline(success: { (tweets: [Tweet]) in
            self.isLoadingTweets = false
            
            self.tweets = tweets
            
            self.tweetsTableView.reloadData()
            
            if let success = success {
                success()
            }
        }) { (Error) in
            self.isLoadingTweets = false
        }
    }
    
    func refreshTweetsControlAction(_ refreshControl: UIRefreshControl) {
        getTweets(success: {
            refreshControl.endRefreshing()
        })
    }
    
    func composeTweet(composer: ComposeTweetViewController, didComposeTweet tweet: Tweet?) {
        getTweets { 
            
        }
        navigationController?.popViewController(animated: true)
        if !(User.currentUser?.justLoggedIn)! {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetsToComposeTweet" {
            let composeTweetViewController = segue.destination as! ComposeTweetViewController
            composeTweetViewController.delegate = self
        } else if segue.identifier == "tweetsToTweetDetail" {
            let selectedTweetIndex = tweetsTableView.indexPathForSelectedRow!
            let tweetDetailViewController = segue.destination as! TweetDetailViewController
            tweetDetailViewController.tweet = tweets[selectedTweetIndex.row]
        } else if segue.identifier == "replyToTweet" {
            if let replyButton = sender as? UIButton {
                let selectedTweetIndex = replyButton.tag
                let composeTweetViewController = segue.destination as! ComposeTweetViewController
                composeTweetViewController.delegate = self
                composeTweetViewController.replyingToTweet = tweets[selectedTweetIndex]
            }
        }
    }

}
