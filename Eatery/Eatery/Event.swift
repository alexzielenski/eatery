//
//  Event.swift
//  Eatery
//
//  Created by Lucas Derraugh on 10/19/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//


class Event: NSObject {
    let summary: String
    let startTime: NSDate
    let endTime: NSDate
    
    init(summary: String, startTime: Int, endTime: Int) {
        self.summary = summary
        self.startTime = NSDate(timeIntervalSince1970: NSTimeInterval(startTime))
        self.endTime = NSDate(timeIntervalSince1970: NSTimeInterval(endTime))
    }
}
