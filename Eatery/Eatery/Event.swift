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
    
    let rule: Rule?
    
    init(json: JSON) {
        summary = json["summary"].stringValue
        start = DateParser.dateFromString(json["start"].stringValue)
        end = DateParser.dateFromString(json["end"].stringValue)
        rule = json["rrule"].dictionary != nil ? Rule(json: json["rrule"]) : nil
    }
    
    override var description: String {
        return "Event: \(summary)starting: \(start) ending: \(end) rule: \(rule)\n"
    }
    
    func startAndEndTimeForToday() -> (start: NSDate, end: NSDate)? {
        let today = NSDate()
        if let r = rule {
            let cal = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            let weekday = cal.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: today).weekday
            if contains(r.weekdays, Weekday(rawValue: weekday)!) {
                return (start, end)
            }
        }
        return nil
    }
    
    // MARK: - NSCoding
    
//    required init(coder aDecoder: NSCoder) {
//        summary = State(rawValue: aDecoder.decodeIntegerForKey("summary"))!
//        start = aDecoder.decodeObjectForKey("start") as NSDate
//        end = aDecoder.decodeObjectForKey("end") as NSDate
//        
//    }
//    
//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encodeObject(summary.rawValue, forKey: "summary")
//        aCoder.encodeObject(start, forKey: "start")
//        aCoder.encodeObject(end, forKey: "end")
//    }
    
}

