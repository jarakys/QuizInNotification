//
//  NetworkRequest.swift
//  iOS 12 Notifications
//
//  Created by Kirill on 8/29/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation

protocol NetworkRequsts{
    func getQuestion() ->  [String]
    func sendAnswer(answer: String)
}

struct QuizRequests : NetworkRequsts {
    
    func getQuestion() -> [String] {
        //some code here
        return [""]
    }
    
    func sendAnswer(answer: String) {
        //some code here
    }
}
