//
//  DataManager.swift
//  Eatery
//
//  Created by Eric Appel on 10/8/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation

// Mark: Eatery API
enum Endpoints: String {
    case Calendars = "calendar"
    case Menus = "menu"
    case Locations = "location"
}

enum CalendarEndpoints: String {
    case ID = "id"
}

enum MenuEndpoints: String {
    case ID = "id"
    case MealType = "meal_type"
}


class DataManager: NSObject {
    
    class var sharedInstance : DataManager {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : DataManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = DataManager()
        }
            
        return Static.instance!
    }
    
    //
    //
    //
    //
}