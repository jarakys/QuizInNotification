//
//  AnswerDatabaseModel.swift
//  iOS 12 Notifications
//
//  Created by Kirill on 9/25/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

struct AnswerDatabaseModel : Codable {
    let Key: String
    let Answer: String
    let QuestionId: String
    let AnswerId: String
}
