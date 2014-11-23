//
//  Menu.swift
//  Eatery
//
//  Created by Lucas Derraugh on 11/19/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class Menu: NSObject {
    let breakfast: [MenuItem]?
    let brunch: [MenuItem]?
    let lunch: [MenuItem]?
    let dinner: [MenuItem]?
    
    init(data: JSON) {
        let toMenuItem: JSON -> MenuItem = { MenuItem(category: $0["category"].stringValue, name: $0["name"].stringValue, healthy: $0["healthy"].boolValue) }
        breakfast = data["breakfast"].arrayValue.map(toMenuItem)
        brunch = data["brunch"].arrayValue.map(toMenuItem)
        lunch = data["lunch"].arrayValue.map(toMenuItem)
        dinner = data["dinner"].arrayValue.map(toMenuItem)
        super.init()
    }
    
    override var description: String {
        return "Breakfast: \(breakfast)\nBrunch: \(brunch)\nLunch: \(lunch)\nDinner: \(dinner)"
    }
}

class MenuItem: NSObject {
    let category: String = ""
    let name: String
    let healthy: Bool = true
    
    private init(category: String, name: String, healthy: Bool) {
        self.category = category
        self.name = name
        self.healthy = healthy
        super.init()
    }
    
    override var description: String {
        return "\tCategory: \(category)\n\tName: \(name)\n\thealthy: \(healthy)\n"
    }
}
