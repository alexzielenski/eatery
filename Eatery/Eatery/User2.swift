//
//  User2.swift
//  Eatery
//
//  Created by Eric Appel on 12/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

private var currentUserInstance: User2? = nil

class User2: NSObject {
    
    override var description: String {
        return "<xxx\nPrinting User:\n    fname: \(fname)\n    lname: \(lname)\n    email: \(email)\n    fbid: \(facebookID)\nxxx>"
    }
    var parseUser: PFUser
    var parseUserID: String {
        return parseUser.objectId
    }
    var fname: String {
        get {
            return parseUser.objectForKey("fname") as String
        }
        set {
            parseUser.setObject(newValue, forKey: "fname")
        }
    }
    var lname: String {
        get {
            return parseUser.objectForKey("lname") as String
        }
        set {
            parseUser.setObject(newValue, forKey: "lname")
        }
    }
    var email: String {
        get {
            return parseUser.objectForKey("email") as String
        }
        set {
            parseUser.setObject(newValue, forKey: "email")
        }
    }
    var facebookID: String {
        get {
            return parseUser.objectForKey("facebookID") as String
        }
        set {
            parseUser.setObject(newValue, forKey: "facebookID")
        }
    }
    var groupmeApiKey: String? {
        get {
            return parseUser.objectForKey("groupmeApiKey") as? String
        }
        set {
            parseUser.setObject(newValue, forKey: "groupmeApiKey")
        }
    }
    var friends: [String] {
        get {
            return parseUser.objectForKey("friends") as [String]
        }
        set {
            parseUser.setObject(newValue, forKey: "friends")
        }
    }
    var requests: [String] {
        get {
            return parseUser.objectForKey("requests") as [String]
        }
        set {
            parseUser.setObject(newValue, forKey: "requests")
        }
    }
    
    var friendUsers: [User2] = []
    
    private var _profilePicture: UIImage?
    var profilePicture: UIImage {
        if (_profilePicture == nil) {
            let path = facebookID + "/picture?type=large"
            let pictureURL: NSURL = NSURL(string: path, relativeToURL: NSURL(string: "https://graph.facebook.com"))!
            _profilePicture = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        }
        
        return _profilePicture!
    }
    
    var isLoggedIn: Bool {
        if let user = PFUser.currentUser() { // Check parse
            if PFFacebookUtils.session().isOpen { // Check facebook
                return true
            }
            return false
        }
        return false
    }

    class var currentUser: User2? {
        get {
            if currentUserInstance == nil {
                let parseUser = PFUser.currentUser()
                if parseUser != nil {
                    self.currentUser = User2(parseUser: parseUser)
                }
            }
            return currentUserInstance
        }
        set {
            currentUserInstance = newValue
        }
    }
    
    init(parseUser: PFUser) {
        self.parseUser = parseUser
    }
    
    class func login(completion: (error: NSError?) -> Void) {
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                println(">>>>>>>>Facebook login failed.")
                completion(error: error!)
            } else {
                User2.currentUser = User2(parseUser: user)
                User2.currentUser!.loadInformation({ (error) -> Void in // get fb info and add extra fields to parse
                    if error != nil {
                        completion(error: error!)
                    }
                    else {
                        if user.isNew {
                            currentUserInstance?.requests = []
                        }
                        User2.currentUser!.parseUser.saveInBackgroundWithBlock(nil)
                        completion(error: nil)
                    }
                })
            }
        })
    }

    /**
        Updates the fields populated by facebook on the currentUserInstance.
        
        Callers of this method are responsible for saving the current user in the completion.
    
        This method should only be called from the User.currentUser instance
    */
    private func updateFBInfo(completion: (error: NSError?) -> Void) {
        FBRequestConnection.startForMeWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                completion(error: error!)
            } else {
                let object = (result as NSDictionary)
                if let swiftyJSON = JSON(rawValue: result) {
                    currentUserInstance?.facebookID = swiftyJSON["id"].stringValue
                    currentUserInstance?.email = swiftyJSON["email"].stringValue
                    currentUserInstance?.fname = swiftyJSON["first_name"].stringValue
                    currentUserInstance?.lname = swiftyJSON["last_name"].stringValue
                    completion(error: nil)
                } else {
                    let error = NSError(domain: "com.eatery", code: 100, userInfo: ["message" : "Error parsing facebook information"])
                    completion(error: error)
                }
            }
        }
    }
    
    /**
        Updates the currentUserInstance's friends.
        
        Callers of this method are responsible for saving the current user in the completion.
        
        This method should only be called from the User.currentUser instance
    */
    private func updateFriendsList(completion:(error: NSError?) -> Void) {
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                completion(error: error!)
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    let friendsJSON = swiftyJSON["data"].arrayValue
                    
                    var friendFacebookIds: [String] = []
                    for friend in friendsJSON {
                        friendFacebookIds.append(friend["id"].stringValue)
                    }
                    
                    println("FB FRIEND IDS:\n \(friendFacebookIds)")
                    
                    var query = PFUser.query()
                    query.whereKey("facebookID", containedIn: friendFacebookIds)
                    
                    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
                        if error == nil && results.count > 0 {
                            //////
                            println("Found \(results.count) friends")
                            println("QUERY RESULTS: \n\(results)")
                            //////

                            var friendParseIds: [String] = []
                            for friend: PFUser in results as [PFUser] {
                                currentUserInstance?.friendUsers.append(User2(parseUser: friend))
                                friendParseIds.append(friend.objectId)
                            }
                            currentUserInstance?.friends = friendParseIds
                            completion(error: nil)
                        } else {
                            // no friends found in parse. set to empty array
                            currentUserInstance?.friends = []
                            completion(error: nil)
                        }
                    }
                } else {
                    let error = NSError(domain: "com.eatery", code: 100, userInfo: ["message" : "Error parsing facebook friends response"])
                    completion(error: error)
                }
            }
        }
    }
    
    private func loadInformation(completion: (error: NSError?) -> Void) {
        // Use GCD to dispatch then wait for the responses instead of chaining FBRequests
        // Load fb self info, then get friend info
        updateFBInfo { (error) -> Void in
            if error != nil {
                completion(error: error!)
            } else {
                self.updateFriendsList({ (error) -> Void in
                    if error != nil {
                        completion(error: error!)
                    } else {
                        println("loaded friends list")
                        completion(error: nil)
                    }
                })
            }
        }
    }
    
    deinit {
        if parseUser.isDirty() && parseUser.isAuthenticated(){
            parseUser.save()
        }
    }

    
}
