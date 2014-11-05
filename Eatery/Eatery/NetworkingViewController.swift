//
//  ViewController.swift
//  Eatery
//
//  Created by Eric Appel on 10/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//
//
//
//
//
//
//
//  ATTENTION: This View Controller is here to give you a reference point for networking calls that you might need to make to Parse, Facebook, or our own backend.  These methods are not meant to be called from anywhere else in the app.  If you need to use one of them, copy it to whichever file you are working in.
//
//  Feel free to add any methods/calls you think would benefit yourself or anyone else on the team but try not to fuck up our Parse db :)


import UIKit

class NetworkingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
    //////////////////////////////////////////////////////////////////////////////////////////
    // Parse
        
        /* BUTTON: Save a parse object */
        let parseDataButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 244, height: 44)))
        parseDataButton.center = CGPoint(x: view.center.x, y: view.center.y - 84)
        parseDataButton.layer.cornerRadius = 5
        parseDataButton.backgroundColor = UIColor.burntOrange()
        parseDataButton.setTitle("Save Parse Test Object", forState: UIControlState.Normal)
        parseDataButton.addTarget(self, action: "parseDataButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(parseDataButton)
        

    //////////////////////////////////////////////////////////////////////////////////////////
    // Scraper

        /* BUTTON: Get a list of dining areas */
        let eateryAPIButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 244, height: 44)))
        eateryAPIButton.center = view.center
        eateryAPIButton.layer.cornerRadius = 5
        eateryAPIButton.backgroundColor = UIColor.carribeanGreen()
        eateryAPIButton.setTitle("Ping Our API", forState: UIControlState.Normal)
        eateryAPIButton.addTarget(self, action: "eateryAPIButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(eateryAPIButton)
        
        
    //////////////////////////////////////////////////////////////////////////////////////////
    // Facebook

        /* BUTTON: Login with facebook */
        let loginButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 244, height: 44)))
        loginButton.center = CGPoint(x: view.center.x, y: view.center.y + 84)
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.facebookBlue()
        loginButton.setTitle("Login With Facebook", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginWithFacebookButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
    }
    
    // MARK: Parse data methods
    func parseDataButtonPressed(sender: UIButton) {
//        var testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
//            if error != nil {
//                error.showAlert()
//            } else {
//                println("\n>>>>>>>>Test Object Saved")
//            }
//        }
        var beaconObject = PFObject(className: "Beacon")
        beaconObject["author"] = "me"
        beaconObject["audience"] = [PFUser.currentUser().objectId]
        beaconObject["startDate"] = NSDate(timeIntervalSince1970: <#NSTimeInterval#>)
        let oneHour: Double = 60*60
        beaconObject["endDate"] = NSDate(timeIntervalSinceNow: oneHour)
        beaconObject.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
            if error != nil {
                error.showAlert()
            } else {
                println("\n>>>>>>>>Beacon Object Saved")
            }
        }
    }
    
    // MARK: eateryAPI methods
    func eateryAPIButtonPressed(sender: UIButton) {
        //// Get a list of dining areas
        DataManager.sharedInstance.getCalendars { (error, result) -> Void in
            if error != nil {
                error!.showAlert()
            } else {
                println("\n>>>>>>>>Got Dining Areas:")
                println(result!)
            }
        }
    }
    
    // MARK: Facebook methods
    func loginWithFacebookButtonPressed(sender: UIButton) {
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            println()
            if user == nil {
                println(">>>>>>>>Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                println(">>>>>>>>User signed up and logged in through Facebook!")
                self.getFacebookInfo()
            } else {
                println(">>>>>>>>User logged in through Facebook!")
                self.getFacebookInfo()
            }
        })
    }
    
    func getFacebookInfo() {
        FBRequestConnection.startForMeWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                error.showAlert()
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    println("My Profile:")
                    println(swiftyJSON)
                    let id = swiftyJSON["id"].stringValue
                    self.printMyFriendsList(id)
                }
            }
        }
    }
    
    func printMyFriendsList(facebookID: String) {
        // This will only print friends who have given our app fb access.  The new api does not allow access to a person's entire friends list.
        FBRequestConnection.startForMyFriendsWithCompletionHandler { (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            if error != nil {
                error.showAlert()
            } else {
                if let swiftyJSON = JSON(rawValue: result) {
                    println("My Friends:")
                    println(swiftyJSON)
                    let friendObjects: Array = swiftyJSON["data"].arrayValue
                    var friendIDs: [String] = []
                    friendIDs.reserveCapacity(friendObjects.count)
                    for fo in friendObjects {
                        friendIDs.append(fo.stringValue)
                    }
                }
            }
        }
    }

}

