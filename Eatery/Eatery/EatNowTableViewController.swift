//
//  EatNowTableViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//
import UIKit

class EatNowTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    override func viewDidLoad() {
		super.viewDidLoad()

        var nib = UINib(nibName: "EatNowTableViewCell", bundle: nil)        
        tableView.registerNib(nib, forCellReuseIdentifier: "eatNowCell")
        
        tableView.rowHeight = 95
        
        //tableView.registerClass(EatNowTableViewCell.classForCoder(), forCellReuseIdentifier: "eatNowCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort By", style: UIBarButtonItemStyle.Plain, target: self, action: "sortBy:")
        
        DataManager.sharedInstance.loadTestData()
        print(DataManager.sharedInstance.diningHalls)
    }
    
    // MARK: - Actions
    
    func sortBy(sender: UIBarButtonItem) {
        
        let sortByViewController = SortByTableViewController()
        let navController = UINavigationController(rootViewController: sortByViewController)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.diningHalls.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eatNowCell", forIndexPath: indexPath) as EatNowTableViewCell

        let name = DataManager.sharedInstance.diningHalls[indexPath.row].name
        let summary = DataManager.sharedInstance.diningHalls[indexPath.row].summary
        let paymentMethods = DataManager.sharedInstance.diningHalls[indexPath.row].paymentMethods
        let hours = DataManager.sharedInstance.diningHalls[indexPath.row].hours
        
        cell.loadItem(image: "appel.jpg", name: name, desc: summary, loc: "poop", paymentMethods: paymentMethods, hours: "8pm to 9pm")
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredPlaces = self.places.filter({(place : Place) -> Bool in
            var stringMatch = place.name.rangeOfString(searchText)
            return (stringMatch != nil)
        })
        
      
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
       
    
        self.filterContentForSearchText(searchString)
        return true
    }
  
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        let detailViewController =  EatNowDetailViewController(nibName: "EatNowDetailViewController", bundle: nil)
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
    
    
    
    
    
    

