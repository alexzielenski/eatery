//
//  BeaconViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class BeaconViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if !User.isLoggedIn {
            let signIn = SignInViewController(nibName: "SignInViewController", bundle: nil)
            signIn.title = self.title
            signIn.navigationItem.setHidesBackButton(true, animated: false)
            signIn.completionHandler = { (error) -> Void in
                if error != nil {
                    error!.handleFacebookError()
                } else {
                    signIn.navigationController?.setViewControllers([self], animated: false)
                }
            }
            self.navigationController?.setViewControllers([signIn], animated: false)
        }
    }
}
