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
        println("vwa")
        if !userIsLoggedIn() {
            let signInViewController: SignInViewController = SignInViewController(nibName: "SignInViewController", bundle: nil)
            signInViewController.navigationItem.setHidesBackButton(true, animated: false)
            navigationController?.setViewControllers([signInViewController], animated: false)
        } else {
            // beacon stuff
        }
    }
}
