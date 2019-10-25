//
//  UserModel.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

struct UserModel : Codable {
    
    let id: String
    let name, phone, token: String
    
}

