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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func facebookDebug() {
        self.showAlert()
        if let swiftyJSON = JSON(rawValue: self.userInfo!) {
            println("1")
            
            println(self)
        }
        println(self.domain)
        println(self.code)
    }
    
    func handleFacebookError() {
        if FBErrorUtility.shouldNotifyUserForError(self) {
            showAlert(FBErrorUtility.userTitleForError(self), message: FBErrorUtility.userMessageForError(self))
        } else {
            println(self.userInfo)
            println("Error Category:")
            println(FBErrorUtility.errorCategoryForError(self).rawValue)
            let errorCategory: FBErrorCategory = FBErrorUtility.errorCategoryForError(self)
            let body = self.userInfo!.keys
            for b in body {
                println(b)
            }
        }
    }
}