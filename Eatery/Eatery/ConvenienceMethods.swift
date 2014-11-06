//
//  ConvenienceMethods.swift
//  Eatery
//
//  Created by Eric Appel on 11/6/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation

func userIsLoggedIn() -> Bool {
    if let user = PFUser.currentUser() { // Check parse
        if PFFacebookUtils.session().isOpen { // Check facebook
            return true
        }
        return false
    }
    return false
}