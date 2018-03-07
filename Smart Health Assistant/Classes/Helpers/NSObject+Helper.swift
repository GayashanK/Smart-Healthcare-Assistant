//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import UIKit

extension NSObject {
    
    func integerValue() -> Int {
        if let val = self as? NSNumber {
            return val.intValue
        } else if let val = self as? String {
            return Int(val) ?? 0
        } else {
            return 0
        }
    }
    
    func doubleValue() -> Double {
        if let val = self as? NSNumber {
            return val.doubleValue
        } else if let val = self as? String {
            return Double(val) ?? 0
        } else {
            return 0
        }
    }
    
    func boolValue() -> Bool {
        if let val = self as? NSNumber {
            return val.boolValue
        } else {
            return false
        }
    }
    
    func stringValue() -> String {
        if let val = self as? NSNumber {
            return "\(val.intValue)"
        } else {
            return self.description
        }
    }
}
