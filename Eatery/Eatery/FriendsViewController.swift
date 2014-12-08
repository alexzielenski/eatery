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
    let primaryName = countElements(user.lname) > 0 ? user.lname : user.fname
    return primaryName.substringToIndex(advance(primaryName.startIndex, 1))
}

private var FRIENDSCTX = 0
class FriendsViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    private(set) var sortedFriends = NSDictionary()
    private var sortedSections = []
    private var modeSegmentedControl: UISegmentedControl!
    private var showsRequested = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        
        self.tableView.registerNib(UINib(nibName: "FriendsListTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
        self.tableView.registerClass(GroupsTableViewCell.self, forCellReuseIdentifier: "GroupsCell")
        User.currentUser?.addObserver(self, forKeyPath: "friends", options: NSKeyValueObservingOptions.allZeros, context: &FRIENDSCTX)
        User.currentUser?.addObserver(self, forKeyPath: "facebookFriends", options: NSKeyValueObservingOptions.allZeros, context: &FRIENDSCTX)
        User.currentUser?.addObserver(self, forKeyPath: "requestedFriends", options: NSKeyValueObservingOptions.allZeros, context: &FRIENDSCTX)
        view.backgroundColor = UIColor.whiteColor()
        
        self.modeSegmentedControl = UISegmentedControl(items: ["Friends", "Facebook"])
        self.modeSegmentedControl.selectedSegmentIndex = 0
        self.modeSegmentedControl.addTarget(self, action: "stateChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = self.modeSegmentedControl
    }

    @objc private func stateChanged(sender: AnyObject?) {
        if (User.isLoggedIn) {            
            if (self.modeSegmentedControl.selectedSegmentIndex == 0) {
                self.showsRequested = User.currentUser!.requestedFriends.count > 0
                self.sortFiendsList(User.currentUser!.friends)
            } else {
                self.showsRequested = false;
                self.sortFiendsList(User.currentUser!.facebookFriends)
            }
        } else {
            self.sortFiendsList([])
        }
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        if !User.isLoggedIn {
            let signIn = SignInViewController(nibName: "SignInViewController", bundle: nil)
            signIn.title = self.title
            signIn.navigationItem.setHidesBackButton(true, animated: false)
            signIn.completionHandler = { (error) -> Void in
                if error != nil {
                    error!.handleFacebookError()
                } else {
                    signIn.navigationController?.setViewControllers([self], animated: false)
                    self.navigationController?.navigationBarHidden = false
                }
            }
            navigationController?.setViewControllers([signIn], animated: false)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (context == &FRIENDSCTX) {
            stateChanged(nil)
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func sortFiendsList(friends: [User]) {
        var sorted = NSMutableDictionary()
        for object in friends {
            let primary = primaryLetterForUser(object)
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
        self.sortedSections = (sorted.allKeys as NSArray).sortedArrayUsingSelector("caseInsensitiveCompare:") as [String]
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = self.sortedSections.count
        if showsRequested {
            count++
        }
        return count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sec = section
        if (showsRequested) {
            sec--
        }
        if (sec == -1) {
            return User.currentUser!.requestedFriends.count
        }
        
        let key: String = self.sortedSections[sec] as String
        return self.sortedFriends[key]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var sec = indexPath.section
        if (showsRequested) {
            sec--;
        }
        
        let cell: FriendsListTableViewCell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as FriendsListTableViewCell
        var user = User.currentUser!
        if (sec == -1) {
            user = user.requestedFriends[indexPath.row]
        } else {
            let key = self.sortedSections[sec] as String
            user = self.sortedFriends[key]![indexPath.row]! as User
        }
        cell.profilePictureView.image = user.profilePicture
        cell.titleField.text = user.name
        cell.isFriend = User.currentUser!.isFriendsWith(user)
        
        cell.touchHandler = {
            [weak user]
            (cell) -> () in
            
            if let user = user {
                if (!cell.isFriend) {
                    User.currentUser!.addFriend(user, completion: { (success) -> () in
                        cell.isFriend = User.currentUser!.isFriendsWith(user)
                    })
                } else {
                    //!TODO remove friend
                }
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sec = section
        if (showsRequested) {
            sec--
        }
        
        if (sec == -1) {
            return "Requested Friends"
        }
        return self.sortedSections[sec] as? String
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return UILocalizedIndexedCollation.currentCollation().sectionIndexTitles
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index)
    }
    
    deinit {
        User.currentUser?.removeObserver(self, forKeyPath: "friends", context: &FRIENDSCTX)
        User.currentUser?.removeObserver(self, forKeyPath: "facebookFriends", context: &FRIENDSCTX)
        User.currentUser?.removeObserver(self, forKeyPath: "requestedFriends", context: &FRIENDSCTX)
    }

}
