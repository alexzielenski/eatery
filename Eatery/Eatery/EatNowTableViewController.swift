//
//  EatNowTableViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class EatNowTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        var nib = UINib(nibName: "EatNowTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "eatNowCell")
        tableView.rowHeight = 95
        super.viewDidLoad()
        
        //tableView.registerClass(EatNowTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
    }
    
    var items: [(String, String, String, String, String)] = [
        ("appel.jpg", "North Star", "Appel Commons - Dining Hall", "0.1mi", "Open until 8:30PM"),
        ("appel.jpg", "RPCC Eatery", "RPCC - Dining Hall", "0.3mi", "Open until 8:30PM"),
        ("appel.jpg", "Bear Necessities", "Appel Commons - Dining Hall", "0.5mi", "Open until 8:30PM"),
        ("appel.jpg", "Cafe Jennie", "Cornell Store - Cafe", "0.1mi", "Open until 8:30PM"),
        ("appel.jpg", "Cascadeli", "Willard Straight Hall - Cafe", "0.3mi", "Open until 8:30PM")
    ]

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eatNowCell", forIndexPath: indexPath) as EatNowTableViewCell

        var (image, name, desc, miles, hours) = items[indexPath.row]

        cell.loadItem(image: image, name: name, desc: desc, miles: miles, hours: hours)
        
        return cell
        //cell.textLabel.text = "Cell (\(indexPath.section),\(indexPath.row))"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController =  EatNowDetailViewController(nibName: "EatNowDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
