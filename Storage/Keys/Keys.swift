//
//  Keys.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
enum Keys : String {
    case User = "User"
    case intervalMin = "timeInterval"
    case AnswerTimeSync = "answerTimeSync"
    func string() -> String {
        return self.rawValue
    }
    
}
