//
//  PFUser+Printable.swift
//  Eatery
//
//  Created by Eric Appel on 11/3/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation

extension PFUser: Printable {
    override public var description: String {
        return "<PFUser:\nusername: \(username)\nemail: \(email)\n>"
    }
}