//
//  SyncManager.swift
//  iOS 12 Notifications
//
//  Created by Kirill Chernov on 9/23/19.
//

import Foundation
import Reachability

struct SyncManager {
    let database: DatabaseManager
    let networking: RequestManager
    let userToken: String
    let reachAbility = Reachability()!
    
    
    init(database: DatabaseManager, networking: RequestManager, token: String) {
        self.database = database
        self.networking = networking
        self.userToken = token
        let userAnswers:[UserAnswerBaseModel] = try! database.getUserAnswer()
        if userAnswers.count > 0 {
            networking.sendAnswers(userAnswers: userAnswers, token: userToken, complition: {result in
                debugPrint(result)
                switch result.result {
                case .success(_:):
                    try! database.deleteAllUserAnswers()
                case .failure(_):
                    print("so sad :(")
                }
            })
        }
    }
    
    func sync(userId: String, questionId: String, questionText: String, isAnswer: Bool, token: String, addedTimeUnix: Int) {
        switch reachAbility.connection {
        case .cellular: fallthrough
        case .wifi:
            sendToServer(userId: userId, questionId: questionId, questionText: questionText, isAnswer: isAnswer, token: token) { statusCode in
                debugPrint(statusCode)
                if statusCode != 204 {
                    self.saveToDataBase(userId: userId, questionId: questionId, questionText: questionText, isAnswer: isAnswer, token: token, addedTimeUnix: addedTimeUnix)
                    self.listenerForInternetStatus(userId: userId, questionId: questionText, questionText: questionText, isAnswer: isAnswer, token: token)
                }
                else {
                    StorageManager.setValue(key: .AnswerTimeSync, value: String(Date().timeIntervalSince1970))
                }
            }
        case .none:
            saveToDataBase(userId: userId, questionId: questionId, questionText: questionText, isAnswer: isAnswer, token: token, addedTimeUnix: addedTimeUnix)
            listenerForInternetStatus(userId: userId, questionId: questionText, questionText: questionText, isAnswer: isAnswer, token: token)
        }
    }
    
    private func listenerForInternetStatus(userId: String, questionId: String, questionText: String, isAnswer: Bool, token: String) {
        reachAbility.whenReachable = { reachability in
            switch reachability.connection {
            case .cellular: fallthrough
            case .wifi:
                self.sendToServer(userId: userId, questionId: questionId, questionText: questionText, isAnswer: isAnswer, token: token) { statusCode in
                    if statusCode == 204 {
                        StorageManager.setValue(key: .AnswerTimeSync, value: String(Date().timeIntervalSince1970))
                        self.removeUserAnswer(questionId: questionId)
                    }
                }
            default:
                print(")))")
            }
        }
    }
    
    private func sendToServer(userId: String, questionId: String, questionText: String, isAnswer: Bool, token: String, completion: @escaping (_ statusCode: Int)->Void) {
        networking.sendAnswers(userAnswers: [UserAnswerBaseModel(questionId: questionId, questionText: questionText, isAnswer: isAnswer)], token: token, complition: {response in
            completion(response.response!.statusCode)
        })
    }
    
    private func removeUserAnswer(questionId: String) {
        let model = try! database.getUserAnswerById(idQuestion: questionId)
        try! database.deleteUserAnswer(userAnswer: model)
    }
    
    private func saveToDataBase(userId: String, questionId: String, questionText: String, isAnswer: Bool, token: String, addedTimeUnix: Int) {
        try! database.createUserAnswers(userId: userId, questionId: questionId, isAnswer: isAnswer, addedTimeUnix: addedTimeUnix, questionText: questionText)
    }
}
