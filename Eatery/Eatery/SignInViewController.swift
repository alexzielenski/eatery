//
//  SignInViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/6/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var fbLoginButton: facebookLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        
        instructionLabel.text = "Login with Facebook to use this screen"
    }

    
    @IBAction func fbButtonPressed(sender: AnyObject) {
        activityIndicator.startAnimating()

        let permissions = [
            "public_profile",
            "email",
            "user_friends"
        ]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            self.activityIndicator.stopAnimating()
            println()
            if user == nil {
                println(">>>>>>>>Facebook login failed.")
                error.handleFacebookError()
            } else if user.isNew {
                println(">>>>>>>>User signed up and logged in through Facebook!")
                self.navigationController?.popToRootViewControllerAnimated(false)
            } else {
                println(">>>>>>>>User logged in through Facebook!")
                self.navigationController?.popToRootViewControllerAnimated(false)
            }
        })
        
        
    }

}
