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
        loginButton.setTitle("Facebook", forState: UIControlState.Normal)
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
//        var beaconObject = PFObject(className: "Beacon")
//        beaconObject["author"] = "me"
//        beaconObject["audience"] = [PFUser.currentUser().objectId]
//        beaconObject["startDate"] = NSDate()
//        beaconObject["endDate"] = NSDate().dateByAddingHours(1)
//        beaconObject.saveInBackgroundWithBlock { (success: Bool!, error: NSError!) -> Void in
//            if error != nil {
//                error.showAlert()
//            } else {
//                println("\n>>>>>>>>Beacon Object Saved")
//            }
//        }
        var testGroup = PFObject(className: "Group")

        var relation = User.sharedInstance.parseUser!.relationForKey("members")
        for user in User.sharedInstance.friendsList.valueForKeyPath("parseUser")! as NSArray {
            println(user);
            relation.addObject(user as PFUser)
        }
        
        testGroup["creator"] = User.sharedInstance.parseUser!
        testGroup["name"] = "ballers"
        testGroup.saveInBackgroundWithBlock(nil)
        println(User.sharedInstance.friendsList.valueForKeyPath("parseUser"));
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
        let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    

}

