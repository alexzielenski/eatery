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
    let events: [Event]
    let id: String
    
    init(location: CLLocation, name: String, summary: String, paymentMethods: [String], hours: [Event], id: String) {
        self.location = location
        self.name = name
        self.summary = summary
        self.paymentMethods = paymentMethods
        self.events = hours
        self.id = id
    }
    
    convenience init(json: JSON) {
        let coords = (json["coordinates"].stringValue).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " ,"))
        let location = CLLocation(latitude: (coords[0] as NSString).doubleValue, longitude: (coords[1] as NSString).doubleValue)
        let name = json["name"].stringValue
        let summary = json["description"].stringValue
        let paymentMethods = (json["payment_methods"].arrayValue).map {$0.stringValue}
        let hours = json["events"].arrayValue.map {Event(json: $0)}
        let id = json["cal_id"].stringValue
        
        self.init(location: location, name: name, summary: summary, paymentMethods: paymentMethods, hours: hours, id: id)
    }
    
    override var description: String {
        return "\(name) has id \(id) with payment methods \(paymentMethods) at location \(location) with events: \(events)"
    }
    
    func pullMenuData(completion:(menu: Menu?) -> Void) {
        DataManager.sharedInstance.updateMenu(id, completion: completion)
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        location = aDecoder.decodeObjectForKey("location") as CLLocation
        name = aDecoder.decodeObjectForKey("name") as String
        summary = aDecoder.decodeObjectForKey("summary") as String
        paymentMethods = aDecoder.decodeObjectForKey("paymentMethods") as [String]
        events = aDecoder.decodeObjectForKey("events") as [Event]
        id = aDecoder.decodeObjectForKey("id") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(summary, forKey: "summary")
        aCoder.encodeObject(paymentMethods, forKey: "paymentMethods")
        aCoder.encodeObject(events, forKey: "events")
        aCoder.encodeObject(id, forKey: "id")
    }
    
}
