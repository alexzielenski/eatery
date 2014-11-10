//
//  Error+Alert.swift
//  Eatery
//
//  Created by Eric Appel on 11/2/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//
//

import Foundation

extension NSError {
     func showAlert() {
        if VERBOSE {
            let alert = UIAlertView(title: "Error!", message: self.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func handleFacebookError() {
        // Present Alert if the user should be notified
        if FBErrorUtility.shouldNotifyUserForError(self) {
            println("<<NOTIFYING USER FOR FBERROR>>\n")
            showAlert(FBErrorUtility.userTitleForError(self), message: FBErrorUtility.userMessageForError(self))
        } else {
            println("<<HANDLING FBERROR WITHOUT ALERT>>\n")
            
            println("Error Category:")
            let errorCategory = FBErrorUtility.errorCategoryForError(self)
            
            handleFBErrorWithCategory(errorCategory)
        }
    }
    
    func handleFBErrorWithCategory(errorCategory: FBErrorCategory) {
        println("--------------------------------FBErrorCategory-----------------------------------")
        switch errorCategory {
        case .Invalid:
            println("Invalid")
        case .Retry:
            println("Retry")
        case .AuthenticationReopenSession:
            println("ReopenSession")
        case .Permissions:
            println("Permission")
        case .Server:
            println("Server")
        case .Throttling:
            println("Throttling")
        case .UserCancelled:
            println("UserCancelled")
        case .FacebookOther:
            println("FacebbokOther")
        case .BadRequest:
            println("BadRequest")
        default:
            println("default case in error category")
        }
        
        if DEBUG {
            packageFBErrorAndShowAlert()
        }
    }
    
    func packageFBErrorAndShowAlert() {
        if let swiftyJSON = JSON(rawValue: userInfo![FBErrorParsedJSONResponseKey]!) {
            println(swiftyJSON)
            
            let error = swiftyJSON["body"]["error"].dictionaryValue
            let errorType = error["type"]!.stringValue
            let errorCode = error["code"]!.stringValue
            let errorMessage = error["message"]!.stringValue
            
            showAlert("\(errorCode) : \(errorType)", message: errorMessage)
        }
    }
    
    func printFBErrorKeys() {
        let keys = userInfo!.keys
        for k in keys {
            println(k)
        }
    }
}
/*

FBError Categories:
{
    FBErrorCategoryInvalid = 0,
    FBErrorCategoryRetry = 1,
    FBErrorCategoryAuthenticationReopenSession = 2,
    FBErrorCategoryPermissions = 3,
    FBErrorCategoryServer = 4,
    FBErrorCategoryThrottling = 5,
    FBErrorCategoryUserCancelled = 6,
    FBErrorCategoryFacebookOther = -1,
    FBErrorCategoryBadRequest = -2,
}


FBErrorCategoryInvalid
Indicates that the error category is invalid and likely represents an error that is unrelated to Facebook or the Facebook SDK
FBErrorCategoryRetry
Indicates that the error may be authentication related but the application should retry the operation. This case may involve user action that must be taken, and so the application should also test the fberrorShouldNotifyUser property and if YES display fberrorUserMessage to the user before retrying.
FBErrorCategoryAuthenticationReopenSession
Indicates that the error is authentication related and the application should reopen the session
FBErrorCategoryPermissions
Indicates that the error is permission related
FBErrorCategoryServer
Indicates that the error implies that the server had an unexpected failure or may be temporarily down
FBErrorCategoryThrottling
Indicates that the error results from the server throttling the client
FBErrorCategoryUserCancelled
Indicates the user cancelled the operation
FBErrorCategoryFacebookOther
Indicates that the error is Facebook-related but is uncategorizable, and likely newer than the current version of the SDK
FBErrorCategoryBadRequest
Indicates that the error is an application error resulting in a bad or malformed request to the server.





*/