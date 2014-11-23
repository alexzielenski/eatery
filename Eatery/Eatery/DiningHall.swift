//
//  DiningHall.swift
//  Eatery
//
//  Created by Lucas Derraugh on 10/19/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit
import CoreLocation

class DiningHall: NSObject, NSCoding {
    let location: CLLocation
    let name: String
    let summary: String
    let paymentMethods: [String]
    var hours: [Event]
    let id: String
    
    var menu: Menu? = nil
    
    init(location: CLLocation, name: String, summary: String, paymentMethods: [String], hours: [Event], id: String) {
        self.location = location
        self.name = name
        self.summary = summary
        self.paymentMethods = paymentMethods
        self.hours = hours
        self.id = id
        super.init()
    }
    
    convenience init(json: JSON) {
        let location = CLLocation(latitude: json["location"]["longitute"].doubleValue, longitude: json["location"]["latitude"].doubleValue)
        let name = json["name"].stringValue
        let summary = json["description"].stringValue
        let paymentMethods = (json["paymentMethods"].arrayValue).map({$0.stringValue})
        let hours = (json["events"].arrayValue).map({Event(summary: $0["summary"].stringValue, startTime: $0["startTime"].intValue, endTime: $0["endTime"].intValue)})
        let id = json["id"].stringValue
        self.init(location: location, name: name, summary: summary, paymentMethods: [""], hours: hours, id: id)
    }
    
    override var description: String {
        return "\n\(name) has id \(id) with payment methods \(paymentMethods)"
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObjectForKey("location") as CLLocation
        name = aDecoder.decodeObjectForKey("name") as String
        summary = aDecoder.decodeObjectForKey("summary") as String
        paymentMethods = aDecoder.decodeObjectForKey("paymentMethods") as [String]
        hours = aDecoder.decodeObjectForKey("hours") as [Event]
        id = aDecoder.decodeObjectForKey("id") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(location)
        aCoder.encodeObject(name)
        aCoder.encodeObject(summary)
        aCoder.encodeObject(paymentMethods)
        aCoder.encodeObject(hours)
        aCoder.encodeObject(id)
    }
    
}
