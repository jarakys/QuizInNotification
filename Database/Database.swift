//
//  CRUD.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/9/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import SQLite

protocol Database {
    func read(tableName: String, predicate: Expression<Bool>) throws -> [Row]
    
//    func getUser() throws -> Row
}
