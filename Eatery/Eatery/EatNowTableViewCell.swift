//
//  EatNowTableViewCell.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class EatNowTableViewCell: UITableViewCell {

    @IBOutlet weak var eateryImage: UIImageView!
    @IBOutlet weak var eateryName: UILabel!
    @IBOutlet weak var eateryDesc: UILabel!
    @IBOutlet weak var eateryMiles: UILabel!
    @IBOutlet weak var eateryHours: UILabel!
    
    func loadItem(#image: String, name: String, desc: String, miles: String, hours: String) {
        eateryImage.image = UIImage(named: image)
        eateryImage.layer.cornerRadius = eateryImage.frame.size.width / 2;
        eateryImage.clipsToBounds = true;
        eateryName.text = name
        eateryDesc.text = desc
        eateryMiles.text = miles
        eateryHours.text = hours
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
