//
//  FriendsListTableViewCell.swift
//  Eatery
//
//  Created by Alexander Zielenski on 12/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    @IBOutlet var friendIndicator: UIButton!;
    @IBOutlet var titleField: UILabel!
    @IBOutlet var profilePictureView: UIImageView!
    
    var touchHandler: ((FriendsListTableViewCell) -> ())?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func friendIndicatorPressed(sender: AnyObject?) {
        println("friend pressed")
        touchHandler?(self);
    }

    // indication of the user being friends with this user
    // in our database rather than simply on facebok
    var isFriend: Bool = false {
        didSet {
            if (isFriend) {
                friendIndicator.imageView?.image = UIImage(named: "heart.jpg")
            } else {
                friendIndicator.imageView?.image = UIImage(named: "ploos.png")
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
