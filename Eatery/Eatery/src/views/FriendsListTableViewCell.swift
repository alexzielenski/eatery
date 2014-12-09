//
//  FriendsListTableViewCell.swift
//  Eatery
//
//  Created by Alexander Zielenski on 12/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    @IBOutlet var friendIndicator: UIImageView!;
    @IBOutlet var titleField: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        friendIndicator = UIImageView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    // indication of the user being friends with this user
    // in our database rather than simply on facebok
    var isFriend: Bool = false {
        didSet {
            if (isFriend) {
                friendIndicator.image = UIImage(named: "appel.jpg")
            } else {
                friendIndicator.image = UIImage(named: "UIApplicationIcon")                
            }
            
        }
    }

    let IMAGESIZE: CGFloat = 32
    let PADDING: CGFloat = 20
    override func layoutSubviews() {
        contentView.addSubview(friendIndicator)
        friendIndicator.frame = CGRect(x: frame.size.width - IMAGESIZE - PADDING, y: CGRectGetMidY(frame) - (IMAGESIZE / 2), width: IMAGESIZE, height: IMAGESIZE)
        super.layoutSubviews()
        
        isFriend = true
        println("layout");
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
