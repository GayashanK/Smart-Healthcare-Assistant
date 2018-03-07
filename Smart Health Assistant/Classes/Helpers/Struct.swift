//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

struct NetworkConst {
    static let baseUrl = "https://api.feeldestination.com/api/v1/"
    
    static let success = "SUCCESS"
    
    struct ErrorMessages {
        static let noDataFound = "No Data Found"
        static let noInternet = "No Internet Connection Available"
        static let dataFetchFail = "Data fetch fail"
    }
}

struct APIURL {
    static func completeUrl(endPoint:endPoint) -> String {
        return NetworkConst.baseUrl + endPoint.rawValue
    }
    static func completeUrl(endPoint:endPoint, endValue: String) -> String {
        return "\(NetworkConst.baseUrl)\(endPoint.rawValue)/\(endValue)"
    }
    static func completeGetUrl(endPoint: endPoint, params: String? = nil, query: String? = nil) -> String {
        var url = NetworkConst.baseUrl + endPoint.rawValue
        if let param = params {
            url = url + "/" + param
        }
        if let qry = query {
            url = url + "?" + qry
        }
        print("GET: " + url)
        return url
    }
}

struct Key {
    static let userId = "key_user_id"
    static let accessToken = "key_access_token"
    static let isGuest = "key_is_guest"
    static let deviceToken = "key_device_token"
    static let userEmail = "key_user_email"
    static let userCountry = "key_user_country"
    static let userFirstName = "key_user_first_name"
    static let userLastName = "key_user_last_name"
    static let userLoginType = "key_user_login_type"
}

struct NotificationIdentifiers {
    static let autoScrollerNotification = Notification.Name("AUTO_SCROLLER")
}

