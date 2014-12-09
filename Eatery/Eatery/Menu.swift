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
    }
    
    override var description: String {
        let bre = breakfast != nil ? "\n\n\t".join(breakfast!.map {$0.description}) + "\n\n" : ""
        let bru = brunch != nil ? "\n\n\t".join(brunch!.map {$0.description}) + "\n\n" : ""
        let lun = lunch != nil ? "\n\n\t".join(lunch!.map {$0.description}) + "\n\n": ""
        let din = dinner != nil ? "\n\n\t".join(breakfast!.map {$0.description}) + "\n\n" : ""
        return "Breakfast:\n\t\(bre) Brunch:\n\t\(bru) Lunch:\n\t\(lun) Dinner:\n\t\(din)"
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
    }
    
    override var description: String {
        return "Category: \(category)\n\tName: \(name)\n\tHealthy: \(healthy)"
    }
}
