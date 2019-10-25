//
//  StorageManager.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
struct StorageManager {
    private static let defaultSettings = UserDefaults.init(suiteName: "group.notificationQuiz.com")
    static func setValue(key: Keys, value: String) {
        defaultSettings?.set(value, forKey: key.string())
    }
    
    static func getValue(key: Keys) -> String? {
        guard let value = defaultSettings?.string(forKey: key.string()) else { return nil}
        return value
    }
    
    static func deleteKey(key: Keys) {
        defaultSettings?.removeObject(forKey: key.string())
    }
}
