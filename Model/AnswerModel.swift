//
//  Answer.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/9/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
struct AnswerModel : Codable{
    
    let id: String
    let text: String
    let key: String
    
    init(id: String, textAnswer: String, key: String) {
        self.id = id
        self.text = textAnswer
        self.key = key
    }
}
