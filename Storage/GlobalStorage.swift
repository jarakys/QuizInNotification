//
//  GlobalStorage.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/12/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
struct GlobalStorage {
    static var user: UserModel?
    
    static var ggg = "sdfsdfsdfsdfsdf"
    
    static func initStorage(){
        guard let data = StorageManager.getValue(key: .User) else { return }
        debugPrint(data)
        user = JsonConverter.jsonToObject(stringJson: data)
    }
}
