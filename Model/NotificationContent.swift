//
//  NotificationContent.swift
//  iOS 12 Notifications
//
//  Created by Kirill on 8/29/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
struct QuizModel : Codable {
    let id: String
    let text:String
    let correctAnswerText:String
    let answer:[AnswerModel]
    
}
