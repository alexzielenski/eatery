//
//  FriendsViewController.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

private func primaryLetterForUser(user: User) -> String {
    // Typically return first letter of last name, but if
    // that isnt available, first letter of name
    let primaryName = user.lastName != nil && countElements(user.lastName) > 0 ? user.lastName : user.name
    return primaryName.substringToIndex(advance(primaryName.startIndex, 1))
}

private var FRIENDSCTX = 0
class FriendsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    private(set) var sortedFriends = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "FriendCell")
        self.tableView.registerClass(GroupsTableViewCell.self, forCellReuseIdentifier: "GroupsCell")
        User.sharedInstance.addObserver(self, forKeyPath: "friendsList", options: NSKeyValueObservingOptions.allZeros, context: &FRIENDSCTX)
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!User.sharedInstance.isLoggedIn) {
            let signIn = SignInViewController(nibName: "SignInViewController", bundle: nil)
            signIn.completionHandler = {
                [unowned self] result in
                
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                self.tableView.reloadData()
            }
            self.navigationController?.presentViewController(signIn, animated: true, completion: nil)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (context == &FRIENDSCTX) {
            self.sortFiendsList(User.sharedInstance.friendsList)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func sortFiendsList(friends: NSArray) {
        var sorted = NSMutableDictionary()
        for object in friends {
            let primary = primaryLetterForUser(object as User)
            var list: NSMutableArray!
            if ((sorted.allKeys as NSArray).containsObject(primary)) {
                list = sorted[primary] as NSMutableArray
            } else {
                list = NSMutableArray()
                sorted[primary] = list
            }
            
            list.addObject(object)
        }
        self.sortedFriends = sorted
        
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + self.sortedFriends.allKeys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        let key: String = self.sortedFriends.allKeys[section - 1] as String
        return self.sortedFriends[key]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0 && indexPath.section == 0) {
            let cell: GroupsTableViewCell = tableView.dequeueReusableCellWithIdentifier("GroupsCell", forIndexPath: indexPath) as GroupsTableViewCell
            return cell
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
        let key: String = self.sortedFriends.allKeys[indexPath.section - 1] as String
        let user:User = self.sortedFriends[key]![indexPath.row]! as User
        cell.textLabel.text = user.name
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return nil;
        }
        
        return self.sortedFriends.allKeys[section - 1] as? String
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 && indexPath.section == 0 ? 72 : tableView.rowHeight
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.sortedFriends.allKeys
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index + 1
    }
    
    deinit {
        User.sharedInstance.removeObserver(self, forKeyPath: "friendsList", context: &FRIENDSCTX)
    }

}
