//
//  QuizParser.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/9/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.

import Foundation
import SQLite
struct QuizParser {
    
    private let idRecord = Expression<String>("Id")
    private let text = Expression<String>("text")
    private let correctanswerText = Expression<String>("correctAnswerText")
    private let key = Expression<String?>("Key")
    private let answer = Expression<String>("Answer")
    private let questionId = Expression<String>("QuestionId")
    private let databaseManager: DatabaseManager!
    
    init(databaseManager: DatabaseManager) {
        self.databaseManager = databaseManager
    }
    
    func getQustion(id: Int) throws -> QuizModel? {
        let idExp = Expression<Int>("Id")
        let data  = try! databaseManager.read(tableName: "Qustions", predicate: idExp == id).first!

        return try parseQuestion(data: data)
    }
    
    private func parseQuestion(data: Row) throws -> QuizModel? {
        let idQuestion = Expression<String>("idQuestion")
        let qRightAnswerId = data[correctanswerText]
        let qustionText = data[text]
        let questionId = data[idQuestion]
        let answers = try getAnswers(id: questionId)
        let questionModel = QuizModel(id: questionId, text: qustionText, correctAnswerText: qRightAnswerId, answer: answers)
        return questionModel
    }
    
    func getRandomQuestion() throws -> QuizModel? {
        let count =  try databaseManager.getCountQuestions()
        let randomNumber = Int.random(in: 0...count)
        let row = try databaseManager.getQuestionByOffset(offset: randomNumber)
        return try parseQuestion(data: row)
    }
    
    private func getAnswers(id: String) throws -> [AnswerModel] {
        var answersModel:[AnswerModel] = []
        let idExp = Expression<String>("QuestionId")
        let idAns = Expression<String>("AnswerId")
        let keyExp = Expression<String>("Key")
        let data  = try! databaseManager.read(tableName: "Answers", predicate: idExp == id)
        for answerRow in data {
            let answ = AnswerModel(id: answerRow[idAns], textAnswer: answerRow[answer], key: answerRow[keyExp])
            debugPrint(answ)
            answersModel.append(answ)
        }
        return answersModel
    }
    
}
