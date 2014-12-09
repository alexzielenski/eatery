//
//  Event.swift
//  Eatery
//
//  Created by Lucas Derraugh on 10/19/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

class Event: NSObject {
    let summary: String
    let start: NSDate
    let end: NSDate
    
    init(json: JSON) {
        summary = json["summary"].stringValue
        start = NSDate(timeIntervalSince1970: NSTimeInterval(json["start"].intValue/1000))
        end = NSDate(timeIntervalSince1970: NSTimeInterval(json["end"].intValue/1000))
    }
    
    override var description: String {
        return "Event: \(summary) starting: \(start) ending: \(end)"
    }
    
    // MARK: - NSCoding
    
    required init(coder aDecoder: NSCoder) {
        summary = aDecoder.decodeObjectForKey("summary") as String
        start = aDecoder.decodeObjectForKey("start") as NSDate
        end = aDecoder.decodeObjectForKey("end") as NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(summary, forKey: "summary")
        aCoder.encodeObject(start, forKey: "start")
        aCoder.encodeObject(end, forKey: "end")
    }
    
}

