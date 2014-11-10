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
    var completionHandler: ((error: NSError?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        instructionLabel.text = "Login with Facebook to use this screen"
    }

    
    @IBAction func fbButtonPressed(sender: AnyObject) {
        User.sharedInstance.login(self.completionHandler)
    }

}
