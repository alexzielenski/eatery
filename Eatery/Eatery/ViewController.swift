//
//  ViewController.swift
//  Eatery
//
//  Created by Eric Appel on 10/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Parse
//        var testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackground()
        
        
        // MARK: DataManager
//        DataManager.sharedInstance.alamoTest { (error) -> Void in
//            if error != nil {
//                error!.showAlert()
//            } else {
//                println("\nRequest Complete.")
//            }
//        }
//        
//        DataManager.sharedInstance.getCalendars { (error, result) -> Void in
//            if error != nil {
//                error!.showAlert()
//            } else {
//                println("\nGot Dining Areas:")
//                println(result!)
//            }
//        }
        
        
        let loginButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 244, height: 44)))
        loginButton.center = view.center
        loginButton.layer.cornerRadius = 5
        loginButton.backgroundColor = UIColor.facebookBlue()
        loginButton.setTitle("Login With Facebook", forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "loginWithFacebook:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(loginButton)
        
        println(PFUser.currentUser())
        
    }
    
    func loginWithFacebook(sender: UIButton) {
        println("login with fb")
        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                println(user)
            } else {
                NSLog("User logged in through Facebook!")
                println(user)
            }
        })
    }

}

