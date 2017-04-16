//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/15/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var isLoadingTweets: Bool = false
    var tweets: [Tweet] = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        
        isLoadingTweets = true
        
        TwitterClient.sharedInstance.getHomeTimeline(success: { (tweets: [Tweet]) in
            self.isLoadingTweets = false
            
            self.tweets = tweets
            
            self.tweetsTableView.reloadData()
        }) { (Error) in
            self.isLoadingTweets = false
        }
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
        
        return tweetCell
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
