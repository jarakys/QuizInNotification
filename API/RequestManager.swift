//
//  RequestManager.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import Foundation
import Alamofire

struct RequestManager  {
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func signUP(user: UserRegisterModel, complition: @escaping (_ result: AFDataResponse<Any>)-> Void) {
        AF.request(url + "account/registration",
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
                    complition(response)
        }
    }
    
    func signIn(user: UserLoginModel, complition: @escaping (_ result: AFDataResponse<Any>)-> Void) {
        AF.request(url + "account/authenticate",
                   method: .post,
                   parameters: user,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
                    complition(response)
        }
    }
    
    func getQuestions(complition: @escaping (_ result: AFDataResponse<Any>)->Void) {
        
        var request = URLRequest(url: URL(string: url+"Questions")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 180 // 10 secs
        AF.request(request as! URLRequestConvertible).responseJSON { response in
            //debugPrint(response)
            complition(response)
        }
    }
    
//    func sendAnswers(userAnswers: UserAnswerBaseModel, token: String, complition: @escaping (_ result: AFDataResponse<Any>)-> Void) {
//        debugPrint(userAnswers)
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer "+token
//        ]
//        AF.request(url + "Statistics",
//                   method: .post,
//                   parameters: userAnswers,
//                   encoder: JSONParameterEncoder.default, headers: headers
//                   ).responseJSON { response in
//                    complition(response)
//        }
//    }
    
    func sendAnswers(userAnswers: [UserAnswerBaseModel], token: String, complition: @escaping (_ result: AFDataResponse<Any>)-> Void) {
        debugPrint("Ueueue", userAnswers)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer "+token
        ]

        AF.request(url + "Statistics",
                   method: .post,
                   parameters: userAnswers,
                   encoder: JSONParameterEncoder.default, headers: headers
            ).responseJSON { response in
                complition(response)
        }
    }
    
}
