//
//  User.swift
//  Eatery
//
//  Created by Alexander Zielenski on 11/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

private enum ResponseKey: NSString {
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
    
    var parseUser: PFUser? {
        if (isMe) {
            return PFUser.currentUser()
        }
        
        return nil
    }
    
    private var _profilePicture: UIImage?
    var profilePicture: UIImage {
        if (self._profilePicture == nil) {
            let path = self.facebookID + "/picture?type=large"
            let pictureURL: NSURL = NSURL(string: path, relativeToURL: NSURL(string: "https://graph.facebook.com"))!
            self._profilePicture = UIImage(data: NSData(contentsOfURL: pictureURL)!)
        }
        
        return self._profilePicture!
    }
    
    // MARK: Facebook user information
    dynamic var friendsList: NSMutableArray = []
    
    // List properties as dynamic to enabled KVO
    dynamic private(set) var birthday: NSDate!
    dynamic private(set) var email: NSString!
    dynamic private(set) var firstName: NSString!
    dynamic private(set) var gender: NSString!
    dynamic private(set) var facebookID: NSString!
    dynamic private(set) var lastName: NSString!
    dynamic private(set) var profileURL: NSURL!
    dynamic private(set) var locale: NSString!
    private(set) var location: (id: NSString, name: NSString)!
    dynamic private(set) var middleName: NSString!
    dynamic private(set) var name: NSString!
    dynamic private(set) var timeZone: Int = 0
    dynamic private(set) var lastUpdated: NSDate!
    dynamic private(set) var isVerified: Bool = false
    
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
        self.loadInformation(nil)
    }
    
    private init(responseDictionary: NSDictionary) {
        super.init()
        
        initializeProperties(responseDictionary)
    }
    
    private func loadInformation(completion: ((result: Bool) -> Void)?) {
        if (self.isLoggedIn) {
            loadUserInfo() {
                [unowned self] result in
                self.loadedUserInfo = true
                
                if (self.isLoggedIn && completion != nil) {
                    completion!(result: true);
                }
                
            }
            
            loadFriendsList() {
                [unowned self] result in
                self.loadedFriendsList = true
                
                if (self.isLoggedIn && completion != nil) {
                    completion!(result: true);
                }
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
    
    private func loadUserInfo(completion: ((result: Bool) -> Void)?) {
        FBRequestConnection.startForMeWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                error.handleFacebookError()
                if let completion = completion {
                    completion(result: false);
                }
            } else {
                let object = (result as NSDictionary)
                self.initializeProperties(object)
                if let completion = completion {
                    completion(result: true)
                }
            }
        }
    }
    
    private func loadFriendsList(completion:((result: Bool) -> Void)?) {
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                error.handleFacebookError()
                if (completion != nil) {
                    completion!(result: false)
                }
            } else {
                if let response = result as? NSDictionary {
                    let data: [NSDictionary]! = (response[ResponseKey.Data.rawValue as String] as? [NSDictionary])
                    if data == nil {
                        println("Error parsing response")
                        if (completion != nil) {
                            completion!(result: false)
                        }
                    }
                    
                    var friends = NSMutableArray(capacity: data.count)
                    for object: NSDictionary in data {
                        friends.addObject(User(responseDictionary: object))
                    }
                    
                    self.friendsList = friends
                } else {
                    println("Error parsing response")
                    if (completion != nil) {
                        completion!(result: false)
                    }
                }
            }
        }
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
    
    func login(completion: ((result: Bool) -> Void)?) {
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
            if user == nil {
                println(">>>>>>>>Facebook login failed.")
                error.handleFacebookError()
                
                if let completion = completion {
                    completion(result: false)
                }
                
            } else {
                if user.isNew {
                    println(">>>>>>>>User signed up and logged in through Facebook!")
                } else {
                    println(">>>>>>>>User logged in through Facebook!")
                }
                
                self.loadInformation(completion)
            }
            
            self.didChangeValueForKey("isLoggedIn")
        })
    }
    
    private class func keyPathsForValuesAffectingIsFinishedLoading() -> NSSet {
        return NSSet(objects: "loadedUserInfo", "loadedFriendsList")
    }
}
