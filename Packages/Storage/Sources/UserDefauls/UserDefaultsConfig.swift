//
//  UserDefaultsConfig.swift
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import UIKit

@propertyWrapper
struct UserDefault<T> {
    
    private let key: String
    private let defaultValue: T
    
    private let userDefaults: UserDefaults
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = UserDefaults(suiteName: AccessGroup.accessGroup) ?? .standard
    }
    
    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            if(object_getClass(newValue)?.description() == "NSNull"){
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

struct UserDefaultsConfig {
    
    @UserDefault(key: "selected_density", defaultValue: 1)
    static var selectedDensity: Int
    
    @UserDefault(key: "default_time_interval_value", defaultValue: 1)
    static var defaultTimeIntervalValue: Int

    @UserDefault(key: "badges_value", defaultValue: 0)
    static var badgesValue: Int
    
    @UserDefault(key: "first_time_usage", defaultValue: nil)
    static var firstTimeUsage: Bool?
}
