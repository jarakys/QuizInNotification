//
//  ViewController.swift
//  iOS 12 Notifications
//
//  Created by Andrew Jaffee on 6/28/18.
//
/*
 
 Copyright (c) 2017-2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit

// SDK required for notifications
import UserNotifications

class ViewController: UIViewController {

    private var databaseManager: DatabaseManager! = nil
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let path  = Bundle.main.path(forResource: "questionsDb", ofType: "db") {
            databaseManager = DatabaseManager(databasePath: path)!
        }
    }
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let requestManager = RequestManager(url: "http://starov88-001-site9.itempurl.com/api/")
        let startTime = CFAbsoluteTimeGetCurrent()
        requestManager.getQuestions{ response in
            debugPrint(response.response?.statusCode)
            
            if response.response?.statusCode != 200 {
                return
            }
            
            let tmpQuestions:[QuestionModel] = JsonConverter.dataToObject(data: response.data!)
            let questions:[QuestionModel] = Array(tmpQuestions.prefix(100))
            var answers:[AnswerDatabaseModel] = []
            if try! self.databaseManager.getCountQuestions() != questions.count {
            var keys = ["a","b","c","d"]
            //Bool shit
            for item in questions {
                var i = 0
                if item.oneAnswer != nil {
                    answers.append(AnswerDatabaseModel(Key: keys[i], Answer: item.oneAnswer!, QuestionId: item.idQuestion, AnswerId: item.idQuestion))
                    i += 1
                }
                if item.twoAnswer != nil {
                    answers.append(AnswerDatabaseModel(Key: keys[i], Answer: item.twoAnswer!, QuestionId: item.idQuestion, AnswerId: item.idQuestion))
                    i += 1
                }
                if item.threeAnswer != nil {
                    answers.append(AnswerDatabaseModel(Key: keys[i], Answer: item.threeAnswer!, QuestionId: item.idQuestion, AnswerId: item.idQuestion))
                    i += 1
                }
                if item.fourAnswer != nil {
                    answers.append(AnswerDatabaseModel(Key: keys[i], Answer: item.fourAnswer!, QuestionId: item.idQuestion, AnswerId: item.idQuestion))
                    i += 1
                }
            }
//                let queue = DispatchQueue.global(qos: .background)
//                queue.async{
                    try! self.databaseManager.deleteAllQuestions()
                    for question in questions {
                        try! self.databaseManager.insertQuestions(question: question)
                    }
                    for answer in answers {
                        try! self.databaseManager.insertAnswers(answer: answer)
                    }
                }
//            }
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Time elapsed for): \(timeElapsed) s.")
            if let val =  StorageManager.getValue(key: .User) {
                debugPrint(val)
                self.performSegue(withIdentifier: "MainBoard", sender: nil)
            }
            else {
                self.performSegue(withIdentifier: "LoginBoard", sender: nil)
            }
        }
    }
}

