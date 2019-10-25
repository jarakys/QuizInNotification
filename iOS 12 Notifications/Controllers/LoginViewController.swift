//
//  LoginViewController.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    private var requestManager: RequestManager! = nil
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    private var databaseManager: DatabaseManager! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
         requestManager = RequestManager(url: "http://starov88-001-site9.itempurl.com/api/")
         if let path  = Bundle.main.path(forResource: "questionsDb", ofType: "db") {
            databaseManager = DatabaseManager(databasePath: path)!
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginClick(_ sender: Any) {
        guard !phoneNumberLabel.text!.isEmpty || !passwordLabel.text!.isEmpty else {
            showAlert(title: "Empty fields", message: "Incorrect data")
            return
        }
        let phoneNumber = phoneNumberLabel.text!.replacingOccurrences(of: "+", with: "", options: .literal, range: nil).replacingOccurrences(of: " ", with: "", options: .literal, range: nil )
        print(phoneNumber)
        let user = UserLoginModel(Phone: phoneNumber, Password: passwordLabel.text!)
        self.progressIndicator.isHidden = false
        requestManager.signIn(user: user, complition: {(result) in
            debugPrint(result)
            switch result.result {
            case .failure:
                self.showAlert(title: "Error", message: "Something wrong")
            case .success:
                do {
                    if result.response?.statusCode == 200 {
                        let jsonText = try JsonConverter.toString(value: result.value!)
                        debugPrint(jsonText)
                        StorageManager.setValue(key: .User, value: jsonText)
                        self.performSegue(withIdentifier: "MainBoard", sender: nil)
                    }
                    else {
                        self.showAlert(title: "Error", message: "Wrong data")
                    }
                }
                catch{
                }
            }
            do { self.progressIndicator.isHidden = true}
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
