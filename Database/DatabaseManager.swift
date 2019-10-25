//
//  DatabaseManager.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/9/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//
import SQLite
import Foundation
struct DatabaseManager : Database {
    
    let databasePath: String
    let databaseConnection: Connection
    
    init?(databasePath: String) {
        self.databasePath = databasePath
        do {
            let fileManager = FileManager.default
            let dbPath = try fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.notificationQuiz.com")!
//.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("questionsDb.db")
                .path
            if !fileManager.fileExists(atPath: dbPath) {
                try fileManager.copyItem(atPath: databasePath, toPath: dbPath)
            }
            databaseConnection = try Connection(dbPath, readonly: false)
        }
        catch {
            return nil
        }
    }
    
    func read(tableName: String, predicate: Expression<Bool>) throws -> [Row] {
        let answers = Table(tableName)
        let tempTable = answers.filter(predicate)
        let result = Array(try! databaseConnection.prepare(tempTable))
        return result
    }
    
    func createUserAnswers(userId: String, questionId: String, isAnswer: Bool, addedTimeUnix: Int, questionText: String) throws {
        let userAnswers = Table("UserAnswers")
        let idUser = Expression<String>("IdUser")
        let idQuestion = Expression<String>("QuestionId")
        let isAnswerExp = Expression<Int>("isAnswer")
        let addedTime = Expression<Int>("AddedTime")
        let questionTextExpr = Expression<String>("QuestionText")
        let insert = userAnswers.insert(idUser <- userId, idQuestion <- questionId, isAnswerExp <- (isAnswer == true ? 1 : 0), addedTime <- addedTimeUnix, questionTextExpr <- questionText)
        try databaseConnection.run(insert)
    }
    
    
    func getUserAnswer() throws -> [UserAnswerModel] {
        let answers = Table("UserAnswers")
        let userAnswers:[UserAnswerModel] = try databaseConnection.prepare(answers).map{ row in
            return try row.decode()
        }
        return userAnswers
    }
    
    func getUserAnswerById(idQuestion: String) throws -> UserAnswerModel {
        let answers = Table("UserAnswers")
        let idQuestionExp = Expression<String>("IdQuestion")
        let temp = answers.filter(idQuestionExp == idQuestion )
        let userAnswer:UserAnswerModel = try Array(try databaseConnection.prepare(temp)).first!.decode()
        return userAnswer
    }
    
    func getCountQuestions() throws -> Int{
        let questions = Table("Qustions")
        let count = try databaseConnection.scalar(questions.count)
        return count
    }
    
    func getQuestionByOffset(offset: Int) throws -> Row {
        let questions = Table("Qustions")
        let query = questions.limit(1, offset: offset)
        let result = Array(try databaseConnection.prepare(query)).first!
        return result
    }
    
    
    func inserUser(user: UserModel) throws {
        let userTable = Table("User")
        try databaseConnection.run(userTable.insert(user))
    }
    
    func insertQuestions(question: QuestionModel) throws {
        let questionTable = Table("Qustions")
        try databaseConnection.run(questionTable.insert(question))
    }
    
    func insertAnswers(answer: AnswerDatabaseModel) throws {
        let answersTable = Table("Answers")
        try databaseConnection.run(answersTable.insert(answer))
    }
    
    func deleteUserAnswer(userAnswer: UserAnswerModel) throws {
        let userAnswersTable = Table("UserAnswers")
        let id = Expression<Int>("Id")
        let temp = userAnswersTable.filter(id == userAnswer.Id)
        try databaseConnection.run(temp.delete())
    }
    
    func deleteAllUserAnswers() throws {
        let userAnswersTable = Table("UserAnswers")
        try databaseConnection.run(userAnswersTable.delete())
    }
    
    func deleteAllQuestions() throws {
        try deleteAllAnswers()
        let questionTable = Table("Qustions")
        try databaseConnection.run(questionTable.delete())
    }
    
    private func deleteAllAnswers() throws {
        let answersTable = Table("Answers")
        try databaseConnection.run(answersTable.delete())
    }
}
