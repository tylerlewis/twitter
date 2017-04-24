//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/22/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    var tweets: [Tweet] = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.separatorInset = UIEdgeInsets.zero
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 100

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.getMentions(success: { (tweets: [Tweet]) in
            self.tweets = tweets
        
            self.tweetsTableView.reloadData()
        }) { (Error) in
            
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
        let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TweetTableCellInMentions") as! TweetTableCell
        let tweet = tweets[indexPath.row]
        cell.initialize(tweet: tweet)
        return cell
    }
    
    @IBAction func onBackTap(_ sender: Any) {
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
