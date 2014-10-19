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
        
        // MARK: DataManager
        DataManager.sharedInstance.alamoTest()
        
        // MARK: Parse
//        var testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackground()
        
    }

}

