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
    
    func alamoTest() {
        println("\nfunc alamoTest()")
        Alamofire
            .request(.GET, "http://httpbin.org/get", parameters: ["foo" : "bar"], encoding: .URL)
            .responseJSON { (request : NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
                let separator = "\n------------------------------------------"
                println(separator + "\nREQUEST")
                println(request)
                println(separator + "\nRESPONSE")
                println(response)
                println(separator + "\nDATA") // raw json
                println(data)
                println(separator + "\nJSON")
                if let swiftyJSON = JSON.fromRaw(data!) { // if object can be converted to JSON
                    
                    println(swiftyJSON)
                    println("SwiftyJSON values:")
                    // Optional value (no additional chaining required :)
                    if let host = swiftyJSON["headers"]["Host"].string {
                        println("host: \(host)")
                    } else {
                        println("error getting value for key: " + "swiftyJSON[\"headers\"][\"Host\"]")
                    }
                    
                    /* 
                    Use .xxxValue to get the non-optional value
                    *
                    *  BEWARE:
                    *  These are the values you will get if nil (taken from SwiftyJSON github page ( https://github.com/SwiftyJSON/SwiftyJSON#non-optional-getter )
                    *
                    **    If not a Number or nil, return 0
                    **    If not a String or nil, return ""
                    **    If not a Array or nil, return []
                    **    If not a Dictionary or nil, return [:]
                    *
                    */
                    let url = swiftyJSON["url"].stringValue
                    println("url: \(url)")
                }
                println(separator + "\nERROR")
                println(error)
        }
    }
    
}