//
//  DateParser.swift
//  Eatery
//
//  Created by Lucas Derraugh on 11/28/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

class DateParser: NSObject {
    
    let dateFormatter: NSDateFormatter
    
    class var sharedInstance : DateParser {
        struct Static {
            static let instance : DateParser = DateParser()
        }
        return Static.instance
    }
    
    private override init() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
    }
    
    class func dateFromString(str: String) -> NSDate {
        if let date = DateParser.sharedInstance.dateFormatter.dateFromString(str) {
            return date
        }
        return NSDate(timeIntervalSince1970: 0)
    }
    
}
