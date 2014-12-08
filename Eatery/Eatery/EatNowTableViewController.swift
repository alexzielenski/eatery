//
//  EatNowTableViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//
import UIKit

class EatNowTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var filteredPlaces: [DiningHall] = []
    
    override func viewDidLoad() {
		super.viewDidLoad()

        let nib = UINib(nibName: "EatNowTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "eatNowCell")
        
        tableView.rowHeight = 95
        
        let customblue = UIColor(red:(77/255.0), green:(133/255.0), blue:(199/255.0), alpha:1.0);

        navigationController?.navigationBar.barTintColor = customblue
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "search:"), animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort by", style: UIBarButtonItemStyle.Plain, target: self, action: "sortBy:")
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Avenir Next", size: 20)!]
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        DataManager.sharedInstance.updateDiningHalls {
            self.tableView.reloadData()
        }
        LocationManager.sharedInstance
    }
    
    // MARK: - Actions
    
    func sortBy(sender: UIBarButtonItem) {
        
        let sortByViewController = SortByTableViewController()
        let navController = UINavigationController(rootViewController: sortByViewController)
        presentViewController(navController, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            tableView.rowHeight = 95
            return self.filteredPlaces.count
            
        } else
        {
            tableView.rowHeight = 95
            return DataManager.sharedInstance.diningHalls.count

        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("eatNowCell") as EatNowTableViewCell
        
        var hall : DiningHall
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            hall = filteredPlaces[indexPath.row]
            
        } else {
            hall = DataManager.sharedInstance.diningHalls[indexPath.row]
        }
        

        
        cell.loadItem(image: "appel.jpg", name: hall.name, desc: hall.summary, loc: "0.1", paymentMethods: hall.paymentMethods, hours: "8pm to 9pm")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredPlaces = DataManager.sharedInstance.diningHalls.filter({(hall: DiningHall) -> Bool in
            var stringMatch = hall.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
  
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Testing
        
        if tableView == searchDisplayController!.searchResultsTableView {
            filteredPlaces[indexPath.row].pullMenuData {
                println($0)
            }
        } else {
            DataManager.sharedInstance.diningHalls[indexPath.row].pullMenuData {
                println($0)
            }
        }
        
        
        let detailViewController = DetailViewController()
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
}
    
    
    
    
    
    

