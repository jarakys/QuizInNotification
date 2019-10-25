//
//  UserAnswerBaseModel.swift
//  iOS 12 Notifications
//
//  Created by Kirill Chernov on 9/24/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

class UserAnswerBaseModel : Codable {
    var QuestionId: String
    
    var QuestionText: String
    
    var isAnswer: Bool
    
    init(questionId:String, questionText:String, isAnswer:Bool) {
        QuestionId = questionId
        QuestionText = questionText
        self.isAnswer = isAnswer
    }
    
    private enum CodingKeys: String, CodingKey {
        case QuestionId
        case QuestionText
        case isAnswer
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        QuestionId = try container.decode(String.self, forKey: .QuestionId)
        QuestionText = try container.decode(String.self, forKey: .QuestionText)
        debugPrint(QuestionId)
        isAnswer =  try container.decode(Int.self, forKey: .isAnswer) == 0 ? false : true
        debugPrint(isAnswer)
    }
}
