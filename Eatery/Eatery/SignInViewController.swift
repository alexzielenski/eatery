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
        instructionLabel.text = "Login with Facebook to use this screen"
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        if User.isLoggedIn {
            completionHandler!(error: nil)
        }
    }

    
    @IBAction func fbButtonPressed(sender: AnyObject) {
        activityIndicator.startAnimating()
        User.sharedInstance.login { (error) -> Void in
            self.activityIndicator.stopAnimating()
            if let completion = self.completionHandler {
                completion(error: error)
            }
        }
        
//        User2.login { (error) -> Void in
//            println("done logging in")
//            self.activityIndicator.stopAnimating()
//            if let completion = self.completionHandler {
//                completion(error: error)
//            }
//        }
    }

}
