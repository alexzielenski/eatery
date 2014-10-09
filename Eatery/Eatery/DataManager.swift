//
//  DataManager.swift
//  Eatery
//
//  Created by Eric Appel on 10/8/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation
import Alamofire

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
    
    func alamoTest() {
        Alamofire
            .request(.GET, "http://httpbin.org/get", parameters: ["foo" : "bar"], encoding: .URL)
            .response { (request : NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
                println("REQUEST")
                println(request)
                println("RESPONSE")
                println(response)
                println("DATA")
                println(NSString(data: data! as NSData, encoding: NSUTF8StringEncoding))
                println("ERROR")
                println(error)
        }

    }
    
    
    
    
    
    
    
    
    
    
}