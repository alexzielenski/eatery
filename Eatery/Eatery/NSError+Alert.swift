//
//  Error+Alert.swift
//  Eatery
//
//  Created by Eric Appel on 11/2/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import Foundation

extension NSError {
     func showAlert() {
        if VERBOSE {
            let alert = UIAlertView(title: "Error!", message: self.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
}