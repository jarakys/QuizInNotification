//
//  Networking.swift
//  iOS 12 Notifications
//
//  Created by Kirill Chernov on 9/23/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
import Alamofire
protocol Networking {
    
    func getQuestions(complition: @escaping (_ result: AFDataResponse<Any>)-> Void)
    
    func sendAnswers(answer: AnswerModel, complition: @escaping (_ result: AFDataResponse<Any>)-> Void)
    
}
