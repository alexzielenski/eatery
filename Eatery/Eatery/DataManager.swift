//
//  DataManager.swift
//  Eatery
//
//  Created by Eric Appel on 10/8/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation
import Alamofire

let DEBUG = true
let VERBOSE = true

let separator = ":------------------------------------------"

//// Mark: Eatery API
//enum Endpoints: String {
//    case Calendars = "calendar"
//    case Menus = "menu"
//    case Locations = "location"
//}
//
//enum CalendarEndpoints: String {
//    case ID = "id"
//}
//
//enum MenuEndpoints: String {
//    case ID = "id"
//    case MealType = "meal_type"
//}

enum Time: String {
    case Today = "today"
    case Tomorrow = "tomorrow"
}

enum MealType: String {
    case Breakfast = "breakfast"
    case Brunch = "Brunch"
    case Lunch = "Lunch"
    case Dinner = "Dinner"
}


/**
Endpoints enum

- SignIn: /rest_sign_in
*/
enum Router: URLStringConvertible {
    static let baseURLString = "https://eatery-web.herokuapp.com"
    case Root
    case Calendars
    case Calendar(String)
    case CalendarRange(String, Time, Time)
    case Menus
    case Menu(String)
    case MenuMeal(String, MealType)
    case Locations
    case Location(String)
    
    var URLString: String {
        let path: String = {
            switch self {
            case .Root:
                return "/"
            case .Calendars:
                return "/calendars"
            case .Calendar(let calID):
                return "/calendars/\(calID)"
            case .CalendarRange(let calID, let start, let end):
                return "/calendars/\(calID)/\(start.rawValue)/\(end.rawValue)/"
            case .Menus:
                return "/menus"
            case .Menu(let menuID):
                return "/menus/\(menuID)"
            case .MenuMeal(let menuID, let meal):
                return "/menus/\(menuID)/\(meal.rawValue)"
            case .Locations:
                return "/locations"
            case .Location(let locationID):
                return "/locations/\(locationID)"
            }
        }()
        return Router.baseURLString + path
    }
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
    
    func alamoTest(completion:(error: NSError?) -> Void) {
        println("\nfunc alamoTest()")
        let parameters = [
            "foo" : "bar"
        ]
        Alamofire
            .request(.GET, "http://httpbin.org/get", parameters: parameters, encoding: .URL)
            .responseJSON { (request : NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
                printNetworkResponse(request, response, data, error)
                if let e = error {
                    completion(error: e) // send error to completion closure
                } else {
                    if let swiftyJSON = JSON(rawValue: data!) { // if object can be converted to JSON
                        
                        println("SwiftyJSON values:")
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
                        
                        completion(error: nil) // call completion closure when request is complete
                    }
                }
        }
    }
    
    func getCalendars(completion:(error: NSError?, result: [String]?) -> Void) {
        println("\nfunc getCalendars()")
        Alamofire
            .request(.GET, Router.Calendars, parameters: nil, encoding: .URL)
            .responseJSON { (request : NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> Void in
                printNetworkResponse(request, response, data, error)
                if let e = error {
                    completion(error: e, result: nil)
                } else {
                    if let swiftyJSON = JSON(rawValue: data!) {
                        
                        let diningAreas = swiftyJSON.arrayValue
                        
                        var result = diningAreas.map({ (element: JSON) -> String in
                            return element.stringValue
                        })
                        completion(error: nil, result: result)
                    }
                }
            }
    }
    
}

func printNetworkResponse(request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) {
    if VERBOSE {
        if error != nil {
            println("ERROR" + separator)
            println(error)
            println("REQUEST" + separator)
            println(request)
            println("RESPONSE" + separator)
            println(response)
        } else {
            println("ERROR" + separator)
            println(error)
            println("REQUEST" + separator)
            println(request)
            println("RESPONSE" + separator)
            println(response)
            println("JSON DATA" + separator) // raw json
            println(data)
            if let swiftyJSON = JSON(rawValue: data!) { // if JSON data can be converted to swiftyJSON
                println("SWIFTY JSON" + separator) // SwiftyJSON
                println(swiftyJSON)
            }
        }
        println(separator)
    }
}
