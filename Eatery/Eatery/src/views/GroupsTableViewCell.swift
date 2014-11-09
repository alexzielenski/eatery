//
//  GroupsTableViewCell.swift
//  Eatery
//
//  Created by Alexander Zielenski on 11/6/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {
    private(set) var collectionController = GroupsCollectionViewController(nibName: "GroupsCollectionViewController", bundle: nil)
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.collectionController.view.frame = self.contentView.bounds
        self.contentView.addSubview(self.collectionController.view)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
