//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static var instance = Utils()
    
    static func showAlert(message: String, viewController: UIViewController, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }

}
