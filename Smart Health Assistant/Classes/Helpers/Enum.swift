//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

enum endPoint : String {
    case login = "user/authenticate"
    case signup = "user"
    case forgot_password = "user/forgot-password"
    case reset_password = "user/reset-password"
}

enum respond : String {
    case loading = "loading"
    case success = "SUCCESS"
    case authFailed = "AUTH_FAILED"
    case recordNotExists = "RECORD_NOT_EXISTS"
    case recordNotExists_ = "-404"
    case noInternet = "-1009"
    case dataFetchFailed = "3"
    case requestTimedout = "-1001"
    case severOperationFailed = "-1003"
    case couldNotConnectServer = "-1004"
    case connectionLost = "-1005"
    case passwordNotMatch = "PASSWORD_NOT_MATCH"
    case `default`
}

enum UserDefaultsKey : String {
    case userId = "key_user_id"
    case accessToken = "key_access_token"
    case isGuest = "key_is_guest"
    case deviceToken = "key_device_token"
    case userEmail = "key_user_email"
    case userCountry = "key_user_country"
    case userFirstName = "key_user_first_name"
    case userLastName = "key_user_last_name"
    case userLoginType = "key_user_login_type"
}

enum ViewControllerIdentifier : String {
    case viewController = "ViewController"
}

enum StoryboardIdentifier : String {
    case main = "Main"
}

enum StoryboardSegueIdnetifier: String {
    case initialSegue = "initialSegue"
    case scannerSegue = "scannerSegue"
    case ecgSegue = "ecgSegue"
}

enum CellIdentifier : String {
    case sideMenuTableCell = "SideMenuTableCell"
    case sideMenuHeaderCell = "SideMenuHeaderCell"
    case scannerTableCell = "ScannerTableCell"
}

/// The option to add a \n or \r or \r\n to the end of the send message
enum MessageOption: Int {
    case noLineEnding,
    newline,
    carriageReturn,
    carriageReturnAndNewline
}

/// The option to add a \n to the end of the received message (to make it more readable)
enum ReceivedMessageOption: Int {
    case none,
    newline
}
