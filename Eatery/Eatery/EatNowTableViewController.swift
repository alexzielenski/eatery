//
//  EatNowTableViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//
import UIKit

class EatNowTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    struct Place {
        let category : String
        let name : String
    }
    
    var places = [Place]()
    var filteredPlaces = [Place]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        var nib = UINib(nibName: "EatNowTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "eatNowCell")
        
        tableView.rowHeight = 95
        
        //tableView.registerClass(EatNowTableViewCell.classForCoder(), forCellReuseIdentifier: "eatNowCell")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort By", style: UIBarButtonItemStyle.Plain, target: self, action: "sortBy:")
        
        
        self.places = [Place(category:"Meal Swipe", name:"Appel Commons"),
            Place(category:"Meal Swipe", name:"RPCC Eatery"),
            Place(category:"BRBs", name:"Bear Necessities"),
            Place(category:"BRBs", name:"Cafe Jennie"),
            Place(category:"BRBs", name:"Trillium"),
            Place(category:"BRBs", name:"Synapsis"),
            Place(category:"BRBs", name:"Green Dragon"),
            Place(category:"BRBs", name:"Amit Bhatia"),
            Place(category:"BRBs", name:"Terrace")]
        
        // Reload the table
        self.tableView.reloadData()
    }
    
    var items: [(String, String, String, String, String)] = [
        
        ("appel.jpg", "North Star", "Appel Commons - Dining Hall", "0.1mi", "Open until 8:30PM"),
        
        ("appel.jpg", "RPCC Eatery", "RPCC - Dining Hall", "0.3mi", "Open until 8:30PM"),
        
        ("appel.jpg", "Bear Necessities", "Appel Commons - Dining Hall", "0.5mi", "Open until 8:30PM"),
        
        ("appel.jpg", "Cafe Jennie", "Cornell Store - Cafe", "0.1mi", "Open until 8:30PM"),
        
        ("appel.jpg", "Cascadeli", "Willard Straight Hall - Cafe", "0.3mi", "Open until 8:30PM")
        
    ]
    
    func sortBy(sender: UIBarButtonItem) {
        
        let sortByViewController = SortByTableViewController()
        let navController = UINavigationController(rootViewController: sortByViewController)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            tableView.rowHeight = 95
            return self.filteredPlaces.count
            
        } else
        {   tableView.rowHeight = 95
            return self.places.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
    
       let cell = self.tableView.dequeueReusableCellWithIdentifier("eatNowCell") as EatNowTableViewCell
        
        var place : Place
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            place = filteredPlaces[indexPath.row]
            
        } else {
            place = places[indexPath.row]
        }
        
       // var (image,  name, desc, miles, hours) = items[indexPath.row]
        cell.loadItem(image: "appel.jpg", name: place.name, desc: "Description", miles: "0.1 mi", hours: "Hours")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
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
    
    
    
    
    
    

