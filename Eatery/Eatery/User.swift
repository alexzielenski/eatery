//
//  User.swift
//  Eatery
//
//  Created by Alexander Zielenski on 11/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

private enum ResponseKey: String {
    case Birthday    = "birthday"
    case Email       = "email"
    case FirstName   = "first_name"
    case Gender      = "gender"
    case ID          = "id"
    case LastName    = "last_name"
    case ProfileURL  = "link"
    case Locale      = "locale"
    case Location    = "location"
    case MiddleName  = "middle_name"
    case Name        = "name"
    case TimeZone    = "timezone"
    case LastUpdated = "update_time"
    case IsVerified  = "verified"
    case Data        = "data"
}

import Foundation

private var sharedUser: User? = nil

class User: NSObject {

    private(set) var facebookID: String {
        get {
            return parseUser.objectForKey("facebookID") as? String ?? ""
        }
        set {
            parseUser.setObject(newValue, forKey: "facebookID")
        }
    }

    private(set) var fname: String {
        get {
            return parseUser.objectForKey("fname") as? String ?? ""
        }
        set {
            parseUser.setObject(newValue, forKey: "fname")
        }
    }
    private(set) var lname: String {
        get {
            return parseUser.objectForKey("lname") as? String ?? ""
        }
        set {
            parseUser.setObject(newValue, forKey: "lname")
        }
    }
    
    private(set) var friendIDs: [String] {
        get {
            return parseUser.objectForKey("friends") as? [String] ?? []
        }
        set {
            parseUser.setObject(newValue, forKey: "friends")
        }
    }
    
    private(set) var requestIDs: [String] {
        get {
            return parseUser.objectForKey("requests") as? [String] ?? []
        }
        set {
            parseUser.setObject(newValue, forKey: "requests")
        }
    }
    
    var groupmeApiKey: String {
        get {
            return parseUser.objectForKey("groupmeApiKey") as? String ?? ""
        }
        set {
            parseUser.setObject(newValue, forKey: "groupmeApiKey")
        }
    }
    
    private(set) var email: String {
        get {
            return parseUser.objectForKey("email") as? String ?? ""
        }
        set {
            parseUser.setObject(newValue, forKey: "email")
        }
    }
    
    var name: String {
        //!TODO: handle the possibility of no last name/first name to deal with spacing
        return fname + " " + lname
    }
    
    var friends: [User] = []
    var facebookFriends: [User] = []
    
    var requests = [User]()
    
    class var isLoggedIn: Bool {
        if let user = PFUser.currentUser() { // Check parse
            if PFFacebookUtils.session().isOpen { // Check facebook
                return true
            }
            return false
        }
        return false
    }
    
    var parseUser: PFUser
    private var _profilePicture: UIImage?
    var profilePicture: UIImage {
        if (_profilePicture == nil) {
            let path = facebookID + "/picture?type=large"
            let pictureURL: NSURL = NSURL(string: path, relativeToURL: NSURL(string: "https://graph.facebook.com"))!
            _profilePicture = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        }
        
        return _profilePicture!
    }
    
    class var currentUser: User? {
        get {
            if (sharedUser == nil) {
                let parseUser = PFUser.currentUser()
                if (parseUser != nil) {
                    self.currentUser = User(user: parseUser)
                }
            }
            return sharedUser
        }
        set {
            sharedUser = newValue
            
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, response, error) -> Void in
                
                if (response != nil) {
                    User.currentUser?.initializeProperties(response as NSDictionary)
                } else {
                    println(error)
                }
            })
            
            User.currentUser?.fetchFriends()
        }
    }
    
    init(user: PFUser) {
        parseUser = user
    }
    
    // Initializes the object given a parse object id
    convenience init(objectId: String) {
        var error: NSError? = nil
        let user = PFUser.query().getObjectWithId(objectId, error: &error)
        if let error = error {
            assert(false, "Encountered error when given object id: " + error.description)
        }
        self.init(user: user as PFUser)
    }
    
    convenience init(facebookID: String) {
        let query = PFUser.query()
        query.whereKey("facebookID", equalTo: facebookID)
        var error: NSError? = nil
        let user = query.getFirstObject(&error) as PFUser?
        
        if let error = error {
            assert(false, "Encountered error when given object id: " + error.description)
        }
        
        self.init(user: user!)
    }
    
    class func login(completion: ((User?, NSError?) -> ())?) {
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        
        // Login for the current facebook session
        PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in
            if (error == nil) {
                User.currentUser = User(user: user)
                completion?(User.currentUser, nil)
            } else {
                println(error);
                completion?(nil, error);
            }
        })
    }
    
    private func fetchFriends() {
        
        // get the friends ids from parse
        parseUser.fetch()

        let query = PFUser.query()
        query.whereKey("objectId", containedIn: friendIDs)
        
        if let friendUsers = query.findObjects() {
            for object in friendUsers {
                self.friends.append(User(user: object as PFUser))
            }
        }
        
        // get the facebook ids from facebook
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (request, result, error) -> Void in
            if (error == nil) {
                let dict = result as NSDictionary
                let data = dict[ResponseKey.Data.rawValue] as NSArray
                
                let facebookIDs = data.valueForKeyPath(ResponseKey.ID.rawValue) as [String]
                let fbquery = PFUser.query()
                fbquery.whereKey("facebookID", containedIn: facebookIDs)
                if let friendUsers = query.findObjects() {
                    for object in friendUsers {
                        self.facebookFriends.append(User(user: object as PFUser))
                    }
                }
                
                
                
            } else {
                //!TODO: handle error
            }
        }
    }
    
    private func initializeProperties(responseDictionary: NSDictionary) {
        facebookID = responseDictionary[ResponseKey.ID.rawValue] as? String ?? ""
        fname = responseDictionary[ResponseKey.FirstName.rawValue] as? String ?? ""
        lname = responseDictionary[ResponseKey.LastName.rawValue] as? String ?? ""
        email = responseDictionary[ResponseKey.Email.rawValue] as? String ?? ""
        if (friendIDs.count == 0) {
            friendIDs = []
        }
        
        if (requestIDs.count == 0) {
            requestIDs = []
        }
        
        
        //!TODO: group me api key
        parseUser.saveEventually()
        
        println(self.facebookID)
    }
    
    deinit {
        if parseUser.isDirty() && parseUser.isAuthenticated() {
            parseUser.save()
        }
    }
    
}
