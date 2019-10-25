//
//  QuestionModel.swift
//  iOS 12 Notifications
//
//  Created by Kirill on 9/25/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

struct QuestionModel : Codable {
    let idQuestion: String
    let text:String
    let correctAnswerText:String
    let fourAnswer: String?
    let oneAnswer: String?
    let threeAnswer: String?
    let twoAnswer: String?
    
}
