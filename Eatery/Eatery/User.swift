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

class User: NSObject {
    private(set) var isMe = false
    dynamic private var loadedUserInfo = false
    dynamic private var loadedFriendsList = false
    dynamic var isFinishedLoading: Bool {
        return self.loadedUserInfo && self.loadedFriendsList
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
    
    var parseUser: PFUser?
    
    private var _profilePicture: UIImage?
    var profilePicture: UIImage {
        if (self._profilePicture == nil) {
            let path = self.facebookID + "/picture?type=large"
            let pictureURL: NSURL = NSURL(string: path, relativeToURL: NSURL(string: "https://graph.facebook.com"))!
            self._profilePicture = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        }
        
        return self._profilePicture!
    }
    
    // MARK: friend user information
    // Includes all facebook friends.
    // to filter by friends who are associated with the current user
    // use valueForKeyPath(isFriend)
    // and to filter by friends who have requested to be friends with the user
    // user valueForKeyPath(isRequested)
    dynamic private(set) var friends: [User] = []
//    dynamic private(set) var requestedFriends: [User] = []
    
    dynamic private(set) var friendIDs = [String]()
    dynamic private(set) var requestedFriendIDs = [String]()
    
    // List properties as dynamic to enabled KVO
    dynamic private(set) var birthday: NSDate!
    dynamic private(set) var email: String!
    dynamic private(set) var firstName: String!
    dynamic private(set) var gender: String!
    dynamic private(set) var facebookID: String!
    dynamic private(set) var lastName: String!
    dynamic private(set) var profileURL: NSURL!
    dynamic private(set) var locale: String!
    private(set) var location: (id: String, name: String)!
    dynamic private(set) var middleName: String!
    dynamic private(set) var name: String!
    dynamic private(set) var timeZone: Int = 0
    dynamic private(set) var lastUpdated: NSDate!
    dynamic private(set) var isVerified: Bool = false
    
    dynamic var isFriend: Bool {
        get {
            if (self.parseUser == nil) {
                return false;
            }
            
            return (User.sharedInstance.friendIDs as NSArray).containsObject(self.parseUser!.objectId)
        }
    }
    
    dynamic var isRequesting: Bool {
        get {
            if (self.parseUser == nil) {
                return false;
            }
            
            return (User.sharedInstance.requestedFriendIDs as NSArray).containsObject(self.parseUser!.objectId)
        }
    }
    
    //MARK: Constructors
    class var sharedInstance: User {
        struct Static {
            static let instance: User = User()
        }
        return Static.instance
    }
    
    private override init() {
        super.init()
        self.isMe = true
//        self.parseUser = PFUser.currentUser()
        var query = PFUser.query()
        query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil && results.count > 0{
                self.parseUser = results[0] as? PFUser
                
                self.requestedFriendIDs = self.parseUser!["requests"] as [String]
                self.friendIDs = self.parseUser!["friends"] as [String]
                
                // Get requested friend objects
//                var requestQuery = PFUser.query()
//                query.whereKey("objectId", containedIn: self.requestedFriendIDs)
//                query.findObjectsInBackgroundWithBlock({ (res, err) -> Void in
//                    if error == nil && res.count > 0 {
//                        // Array of PFUser objects
//                        
//                    }
//                })
            }
        }
        
        self.loadInformation(nil)
    }
    
    private init(responseDictionary: NSDictionary) {
        super.init()
        initializeProperties(responseDictionary)

        var query = PFUser.query()
        query.whereKey("facebookID", equalTo: self.facebookID)
        
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            if error == nil && results.count > 0{
                self.parseUser = results[0] as? PFUser

            }
        }
    }
    
    // Populates the class' properties from a raw response dictionary
    private func initializeProperties(responseDictionary: NSDictionary) {
        let dateFormatter = NSDateFormatter()
        // http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
        dateFormatter.dateFormat = "MM/dd/yyyy"
       
        self.birthday = dateFormatter.dateFromString(responseDictionary[ResponseKey.Birthday.rawValue] as? String ?? "") ?? NSDate()
        self.email = responseDictionary[ResponseKey.Email.rawValue] as? String ?? ""
        self.firstName = responseDictionary[ResponseKey.FirstName.rawValue] as? String ?? ""
        self.gender = responseDictionary[ResponseKey.Gender.rawValue] as? String ?? ""
        self.facebookID = responseDictionary[ResponseKey.ID.rawValue] as? String ?? ""
        self.lastName = responseDictionary[ResponseKey.LastName.rawValue] as? String ?? ""
        self.profileURL = NSURL(string: responseDictionary[ResponseKey.ProfileURL.rawValue] as? String ?? "http://facebook.com")!
        self.locale = responseDictionary[ResponseKey.Locale.rawValue] as? String ?? ""

        let location: AnyObject? = responseDictionary[ResponseKey.Location.rawValue]
        if let loc = location as? NSDictionary {
            //!TODO: give these their own enum keys
            let locationID = loc[ResponseKey.ID.rawValue] as String
            let locationName = loc[ResponseKey.Name.rawValue] as String
            
            self.location = (id: locationID, name: locationName)
        }
        self.middleName = responseDictionary[ResponseKey.MiddleName.rawValue] as? String ?? ""
        self.name = responseDictionary[ResponseKey.Name.rawValue] as? String ?? ""
        self.timeZone = responseDictionary[ResponseKey.TimeZone.rawValue] as? Int ?? 0

        //!TODO: last updated date format
        
        self.isVerified = ((responseDictionary[ResponseKey.IsVerified.rawValue] as? Int ?? 0) == 1) ? true : false
    }
    
    private func loadInformation(completion: ((error: NSError?) -> Void)?) {
        // Use GCD to dispatch then wait for the responses instead of chaining FBRequests
        if isLoggedIn {
            loadUserInfo({ (error) -> Void in
                if error != nil {
                    if let completion = completion {
                        error!.handleFacebookError()
                        completion(error: error)
                    }
                } else {
                    self.loadedUserInfo = true
                    
                    self.loadFriendsList({ (error) -> Void in
                        if error != nil {
                            if let completion = completion {
                                error!.handleFacebookError()
                                completion(error: error)
                            }
                        } else {
                            self.loadedFriendsList = true
                            
                            if let completion = completion {
                                completion(error: nil)
                            }
                        }
                    })
                }
            })
            
        } else {
            if let completion = completion {
                let error = NSError(domain: "com.eatery", code: 100, userInfo: ["message" : "Tried loading facebook information but ws not logged in"])
                completion(error: error)
            }
        }
    }
    
    private func loadUserInfo(completion: ((error: NSError?) -> Void)?) {
        FBRequestConnection.startForMeWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                if let completion = completion {
                    completion(error: error!)
                }
            } else {
                let object = (result as NSDictionary)
                self.initializeProperties(object)
                if let completion = completion {
                    completion(error: nil)
                }
            }
        }
    }
    
    private func loadFriendsList(completion:((error: NSError?) -> Void)?) {
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                if let completion = completion {
                    completion(error: error!)
                }
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    let friendObjects: Array = swiftyJSON["data"].arrayValue
                    var friendUsers: [User] = []

                    friendUsers.reserveCapacity(friendObjects.count)
                    for fo in friendObjects {
                        let friendUser = User(responseDictionary: fo.dictionaryObject!)
                        friendUsers.append(friendUser)
                    }
                    self.friends = friendUsers
                    
                    if let completion = completion {
                        completion(error: nil)
                    }
                } else {
                    if let completion = completion {
                        let error = NSError(domain: "com.eatery", code: 100, userInfo: ["message" : "Error parsing facebook friends response"])
                        completion(error: error)
                    }
                }
            }
        }
    }
    
    func login(completion: ((error: NSError?) -> Void)?) {
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            
            self.willChangeValueForKey("isLoggedIn")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error != nil {
                println(">>>>>>>>Facebook login failed.")
                if let completion = completion {
                    completion(error: error!)
                }
            } else {
                self.loadInformation({ (error) -> Void in
                    if error != nil {
                        if let completion = completion {
                            completion(error: error!)
                        }
                    }
                    else {
                        self.didChangeValueForKey("isLoggedIn")
                        if user.isNew {
                            println(">>>>>>>>User signed up and logged in through Facebook!")
                            // set additional properties on parse
                            user["facebookID"] = self.facebookID
                            user["name"] = self.name
                            user["email"] = self.email
                            user.saveInBackgroundWithBlock(nil)
                        } else {
                            println(">>>>>>>>User logged in through Facebook!")
                            // check if facebook info has changed
                            if user["name"] as? String != self.name || user["email"] as? String != self.email  {
                                user["name"] = self.name
                                user["email"] = self.email
                                user.saveInBackgroundWithBlock(nil)
                            }
                        }
                        if let completion = completion {
                            completion(error: nil)
                        }
                    }
                })
            }
        })
    }
    
    private class func keyPathsForValuesAffectingIsFinishedLoading() -> NSSet {
        return NSSet(objects: "loadedUserInfo", "loadedFriendsList")
    }
}
