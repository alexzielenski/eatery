//
//  DiningMenuDetailViewController.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 12/1/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit

class DiningMenuDetailViewController: UIViewController {

    //Colors////////////
    let backgroundColor = UIColor.lightGrayColor()
    ///////////////////////////
    
    var menu:Menu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = self.backgroundColor
        
        // Do any additional setup after loading the view.
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
