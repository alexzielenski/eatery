//
//  LocationInfoViewController.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 11/19/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit
import CoreLocation

class LocationInfoViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        var info = UITextView(frame: self.view.frame)
        info.textAlignment = NSTextAlignment.Center
        info.text = "LOCATION INFO"
        self.view.addSubview(info)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
