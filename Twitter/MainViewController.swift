//
//  MainViewController.swift
//  Twitter
//
//  Created by Tyler Hackley Lewis on 4/22/17.
//  Copyright © 2017 Tyler Hackley Lewis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMarginConstraint: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if oldContentViewController != nil {
                oldContentViewController.willMove(toParentViewController: nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMove(toParentViewController: nil)
            }
            
            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3) { 
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initNotificationObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMarginConstraint = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originalLeftMarginConstraint + translation.x
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = 150
                } else {
                    self.leftMarginConstraint.constant = 0
                }
            })
        }
    }
    
    func initNotificationObservers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        NotificationCenter.default.addObserver(forName: Navigation.profileImageTappedNotification, object: nil, queue: OperationQueue.main) { (Notification) in
            
            let user = User(user: Notification.userInfo as! NSDictionary)
            Profile.isCurrentUser = false
            Profile.user = user
            
            // Take user to this profile page
            let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
            self.contentViewController = profileNavigationController
        }
        
        NotificationCenter.default.addObserver(forName: Navigation.backToHomeTimelineNotification, object: nil, queue: OperationQueue.main) { (Notification) in

            // Take user back to the home timeline
            let tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
            self.contentViewController = tweetsNavigationController
        }
    }
    
    func extractUser(notification: Notification) -> User {
        let user = User(user: notification.userInfo as! NSDictionary)
        return user
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
