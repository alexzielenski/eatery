//
//  DiningHall.swift
//  Eatery
//
//  Created by Lucas Derraugh on 10/19/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit
import CoreLocation

class DiningHall: NSObject {
    let location: CLLocation
    let name: String
    let summary: String
    let paymentMethods: [String]
    let hours: [Event]
    let id: String
    
    init(location: CLLocation, name: String, summary: String, paymentMethods: [String], hours: [Event], id: String) {
        self.location = location
        self.name = name
        self.summary = summary
        self.paymentMethods = paymentMethods
        self.hours = hours
        self.id = id
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
}
