//
//  ViewController.swift
//  StaterPack-iOS-swift-4.0
//
//  Created by Kasun Gayashan on 2/7/18.
//  Copyright © 2018 cis4. All rights reserved.
//

import Foundation

class UserDefaultsHelper:NSObject {
    
    static var instance = UserDefaultsHelper()
    
    func set(value:Int, key:UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey:key.rawValue)
    }
    
    func set(value:String, key:UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey:key.rawValue)
    }
    
    func get(key:UserDefaultsKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    func get(key:UserDefaultsKey) -> String? {
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    func get(key:UserDefaultsKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
}
