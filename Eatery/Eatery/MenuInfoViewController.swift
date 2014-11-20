//
//  MenuInfoViewController.swift
//  MenuSlider
//
//  Created by Dennis Fedorko on 11/19/14.
//  Copyright (c) 2014 Dennis F. All rights reserved.
//

import UIKit

class MenuInfoViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        var info = UITextView(frame: self.view.frame)
        info.textAlignment = NSTextAlignment.Center
        info.text = "MENU INFO"
        self.view.addSubview(info)
        
        let item = UIView(frame: CGRectMake(0, self.view.frame.size.height - 100, 100, 100))
        item.backgroundColor = UIColor.redColor()
        self.view.addSubview(item)

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
