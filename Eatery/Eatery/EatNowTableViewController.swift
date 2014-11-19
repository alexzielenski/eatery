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
		super.viewDidLoad()

        var nib = UINib(nibName: "EatNowTableViewCell", bundle: nil)        
        tableView.registerNib(nib, forCellReuseIdentifier: "eatNowCell")
        tableView.rowHeight = 95

        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "search:"), animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort By", style: UIBarButtonItemStyle.Plain, target: self, action: "sortBy:")
    }
    
    var items: [(String, String, String, String, String)] = [
        ("appel.jpg", "North Star", "Appel Commons - Dining Hall", "0.1mi", "Open until 8:30PM"),
        ("appel.jpg", "RPCC Eatery", "RPCC - Dining Hall", "0.3mi", "Open until 8:30PM"),
        ("appel.jpg", "Bear Necessities", "Appel Commons - Dining Hall", "0.5mi", "Open until 8:30PM"),
        ("appel.jpg", "Cafe Jennie", "Cornell Store - Cafe", "0.1mi", "Open until 8:30PM"),
        ("appel.jpg", "Cascadeli", "Willard Straight Hall - Cafe", "0.3mi", "Open until 8:30PM")
    ]
    
    // MARK: - Actions
    
    func sortBy(sender: UIBarButtonItem) {
        let sortByViewController = SortByTableViewController()
        let navController = UINavigationController(rootViewController: sortByViewController)
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func search(sender: UIBarButtonItem) {
        println("Search Not Implemented")
    }

    // MARK: - Table view data source

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
    
}
