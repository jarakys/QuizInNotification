//
//  UserAnswerModel.swift
//  iOS 12 Notifications
//
//  Created by Kirill Chernov on 9/24/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

class UserAnswerModel: UserAnswerBaseModel  {
    var Id: Int
    var IdUser: String
    var AddedTime: Int
    
    init(id:Int, idUser:String, addedTime:Int, questionId: String, questionText: String, isAnswer: Bool) {
        Id = id
        IdUser = idUser
        AddedTime = addedTime
        super.init(questionId: questionId, questionText: questionText, isAnswer: isAnswer)
    }
    
    private enum CodingKeys: String, CodingKey {
        case Id
        case IdUser
        case AddedTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        Id = try container.decode(Int.self, forKey: .Id)
        debugPrint(Id)
        IdUser = try container.decode(String.self, forKey: .IdUser)
        debugPrint(IdUser)
        AddedTime = try container.decode(Int.self, forKey: .AddedTime)
        debugPrint(AddedTime)
        try super.init(from: decoder)
    }
    
}
