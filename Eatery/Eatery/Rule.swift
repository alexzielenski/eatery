//
//  Rule.swift
//  Eatery
//
//  Created by Lucas Derraugh on 11/28/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

// Used Int to convert NSDateComponents Weekday easier
enum Weekday: Int, Printable {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var description : String {
        switch self {
        case .Sunday: return "SU";
        case .Monday: return "MO";
        case .Tuesday: return "TU";
        case .Wednesday: return "WE";
        case .Thursday: return "TH";
        case .Friday: return "FR";
        case .Saturday: return "SA";
        default: "Impossible Weekday"
        }
    }
    
    static func daily() -> [Weekday] {
        return [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
    }
    
    static func daysFromString(str: String) -> [Weekday] {
        let list = str.lowercaseString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " ,"))
        var returnList: [Weekday] = []
        for v in list {
            switch v.lowercaseString {
            case "su":
                returnList.append(Sunday)
            case "mo":
                returnList.append(Monday)
            case "tu":
                returnList.append(Tuesday)
            case "we":
                returnList.append(Wednesday)
            case "th":
                returnList.append(Thursday)
            case "fr":
                returnList.append(Friday)
            case "sa":
                returnList.append(Saturday)
            default:
                println("Error in Frequency parsing")
            }
        }
        return returnList
    }
    
}

class Rule: NSObject {
    let weekdays: [Weekday]
    let end: NSDate
    
    init(json: JSON) {
        switch json["frequency"].stringValue.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) {
        case "weekly":
            weekdays = Weekday.daysFromString(json["weekdays"].stringValue)
        case "daily":
            weekdays = Weekday.daily()
        default:
            weekdays = []
        }
        end = DateParser.dateFromString(json["end"].stringValue)
    }
    
    override var description: String {
        return "Rule: \(weekdays) ending on \(end)\n"
    }
}
