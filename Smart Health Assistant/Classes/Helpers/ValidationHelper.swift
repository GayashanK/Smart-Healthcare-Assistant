//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

class ValidationHelper: NSObject {
    
    static var instance = ValidationHelper()

    func validateEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidName(name:String) -> Bool {
        let regex = try! NSRegularExpression(pattern:  "^[a-zàâçéèêëîïôûùüÿñæœ .]+$", options: [.caseInsensitive])
        return regex.firstMatch(in: name, options:[], range: NSMakeRange(0, name.count)) != nil
    }
    
    func validatePassword(password:String) -> Bool {
        return true
    }
    
    func validatePassword(password:String) -> String {
        if password == "" {
            return "Password cannot be empty"
        } else if password.count < 8 {
            return "Must have at lease 8 charactors"
        } else {
            return ""
        }
    }
    
    func messageForErrorCode(error:String) -> String {
        switch error {
        case respond.authFailed.rawValue:
            return "Email or Password Incorrect"
        default:
            return "Something went wrong"
        }
    }
    
    func getErrorMessage(errorCode: String) -> String {
        if let value = respond(rawValue: errorCode) {
            switch value {
            case .authFailed:
                return "Oops.. Another device has logged in with your account."
            case .recordNotExists:
                return "No data found."
            case .recordNotExists_:
                return "No data found."
            case .noInternet:
                return "No Internet Connection"
            case .dataFetchFailed:
                return "Data Fetch Failed"
            case .requestTimedout:
                return "Looks like the server is taking too long to respond"
            case .severOperationFailed:
                return "Something is technically wrong!"
            case .couldNotConnectServer:
                return "Something is technically wrong!"
            case .connectionLost:
                return "Connection Lost"
            default:
                return "Something went wrong."
            }
        }
        return "Something went wrong"
    }
    
}
