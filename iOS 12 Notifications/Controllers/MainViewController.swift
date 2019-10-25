//
//  MainViewController.swift
//  iOS 12 Notifications
//
//  Created by Dmitriy Chumakov on 9/11/19.
//  Copyright © 2019 Andrew Jaffee. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
class MainViewController: UIViewController {

    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var frequencyNotificationLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var timePicker: UIPickerView! {
        didSet {
            self.timePicker.dataSource = self
            self.timePicker.delegate = self
        }
    }
    
    private var timeInterval:Double! = nil
    //private var databaseManager: DatabaseManager! = nil
    private let time = Array(1...59)
    override func viewDidLoad() {
        super.viewDidLoad()
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        if let time = StorageManager.getValue(key: .intervalMin) {
            timeInterval = Double(time)
            debugPrint(Int(timeInterval))
            frequencyNotificationText(value: Int(timeInterval).description)
        }
        else {

            timeInterval = Double(1)
            timePicker.selectedRow(inComponent: self.time.firstIndex(of: Int(1))!)
            frequencyNotificationText(value: timeInterval.description)
        }
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "debitOverdraftNotification", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])
    }
    
    @IBAction func sendNotificationButtonTapped(_ sender: Any) {
        let time = timeInterval * 60.0
        startNotif(time: 10, isRepeat: false, uuidString: "quickNotif")
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            self.startNotif(time: time, isRepeat: true, uuidString: "notificationSyject")
        }
    }
    
//    @objc func appMovedToBackground() {
//        startNotif(time: 10, isRepeat: false)
//    }
    
    
    private func startNotif(time: TimeInterval, isRepeat: Bool, uuidString: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuidString])
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "debitOverdraftNotification"
        content.title = "Swipe for quiz"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: isRepeat)
        let uuidString = uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func frequencyNotificationText(value: String) {
        timeButton.setTitle("M: " + value, for: .normal)
    }
    
    @IBAction func selectTimeAction(_ sender: Any) {
        timePicker.selectRow(self.time.firstIndex(of: Int(timeInterval))!, inComponent: 0, animated: false)
        timePicker.isHidden = false
    }
    
    @IBAction func frequencyChanged(_ sender: Any) {
        frequencyNotificationText(value: Int(stepper.value).description)
        timeInterval = stepper.value
        StorageManager.setValue(key: .intervalMin, value: timeInterval.description)
    }
    
    @IBAction func logoutClick(_ sender: Any) {
         UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notificationSyject"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["quickNotif"])
        StorageManager.deleteKey(key: .User)
    }
}

extension MainViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time.count
    }
}

extension MainViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(time[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timePicker.isHidden = true
        timeInterval = Double(time[row])
        frequencyNotificationText(value: time[row].description)
        StorageManager.setValue(key: .intervalMin, value: timeInterval.description)
    }
}
