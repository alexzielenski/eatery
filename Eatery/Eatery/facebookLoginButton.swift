//
//  facebookLoginButton.swift
//  Eatery
//
//  Created by Eric Appel on 11/5/14.
//  Copyright (c) 2014 CUAppDev. All rights reserved.
//

import UIKit

enum LoginState {
    case LoggedIn
    case LoggedOut
}

class facebookLoginButton: UIButton {
    
    var loginState: LoginState
    
    override init(frame: CGRect) {
        loginState = .LoggedOut
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.facebookBlue()
        setTitle("Login With Facebook", forState: UIControlState.Normal)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        loginState = .LoggedOut
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5
        backgroundColor = UIColor.facebookBlue()
        setTitle("Login With Facebook", forState: UIControlState.Normal)

    }

    func setLoginState(state: LoginState) {
        switch state {
        case .LoggedIn:
            setTitle("Logout", forState: UIControlState.Normal)
            loginState = .LoggedIn
        case .LoggedOut:
            setTitle("Login With Facebook", forState: UIControlState.Normal)
            loginState = .LoggedOut
        }
        
    }
    
    func toggleLoginState() {
        switch loginState {
        case .LoggedIn:
            setTitle("Login With Facebook", forState: UIControlState.Normal)
            loginState = .LoggedOut
        case .LoggedOut:
            setTitle("Logout", forState: UIControlState.Normal)
            loginState = .LoggedIn
        }
    }
}
