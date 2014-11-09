//
//  ProfileViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var fbLoginButton: facebookLoginButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if isLoggedIn() {
            fbLoginButton.setLoginState(.LoggedIn)
            getFacebookInfo({ (result) -> Void in
                self.updateUIWithFacebookProfile(result)
            })
        }
    }
        
    func isLoggedIn() -> Bool {
        return userIsLoggedIn()
    }
    
    func updateUIWithFacebookProfile(profile: JSON) {
        let path = profile["id"].stringValue + "/picture?type=large"
        let pictureURL: NSURL = NSURL(string: path, relativeToURL: NSURL(string: "https://graph.facebook.com"))!
        profileImageView.image = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        
        nameLabel.text = profile["name"].stringValue
        
        title = nameLabel.text
        
        getMyFriendsList(profile["id"].stringValue, completion: { (result) -> Void in
            if let friends = result {
                self.bodyTextView.text = "My Friends:\n\(friends)\n\nUser Info:\n\(profile)"
            } else {
                self.bodyTextView.text = "User Info:\n\(profile)"
            }
        })
        
        
    }

    @IBAction func fbButtonPressed(sender: facebookLoginButton) {
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        if sender.loginState == .LoggedOut {
            User.sharedInstance.login({ (result) -> Void in
//                updateUIWithFacebookProfile(<#profile: JSON#>)
            })
        } else {
            PFUser.logOut()
            updateUIWithFacebookProfile(nil)
            sender.setLoginState(.LoggedOut)
        }
    }
    
    func getFacebookInfo(completion:(result: JSON) -> Void) {
        activityIndicator.startAnimating()
        FBRequestConnection.startForMeWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            self.activityIndicator.stopAnimating()
            if error != nil {
                error.handleFacebookError()
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    completion(result: swiftyJSON)
                }
            }
        }
    }
    
    func getMyFriendsList(facebookID: String, completion:(result: JSON?) -> Void) {
        // This will only print friends who have given our app fb access.  The new api does not allow access to a person's entire friends list.
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                error.handleFacebookError()
                completion(result: nil)
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    let friendObjects: Array = swiftyJSON["data"].arrayValue
                    var friendIDs: [String] = []
                    friendIDs.reserveCapacity(friendObjects.count)
                    for fo in friendObjects {
                        friendIDs.append(fo.stringValue)
                    }
                    completion(result: swiftyJSON)
                }
                else {
                    completion(result: nil)
                }
            }
        }
    }

}
