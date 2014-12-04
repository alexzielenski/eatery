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
        
        let customblue = UIColor(red:(77/255.0), green:(133/255.0), blue:(199/255.0), alpha:1.0);

        self.navigationController?.navigationBar.barTintColor = customblue

        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "search:"), animated: true)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort by", style: UIBarButtonItemStyle.Plain, target: self, action: "sortBy:")
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        DataManager.sharedInstance.loadTestData()
        print(DataManager.sharedInstance.diningHalls)
    }
    
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
        return DataManager.sharedInstance.diningHalls.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eatNowCell", forIndexPath: indexPath) as EatNowTableViewCell

        let name = DataManager.sharedInstance.diningHalls[indexPath.row].name
        let summary = DataManager.sharedInstance.diningHalls[indexPath.row].summary
        let paymentMethods = DataManager.sharedInstance.diningHalls[indexPath.row].paymentMethods
        let hours = DataManager.sharedInstance.diningHalls[indexPath.row].hours
        
        cell.loadItem(image: "appel.jpg", name: name, desc: summary, loc: "loc", paymentMethods: paymentMethods, hours: "8pm to 9pm")
        
        return cell
        //cell.textLabel.text = "Cell (\(indexPath.section),\(indexPath.row))"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController =  EatNowDetailViewController(nibName: "EatNowDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
