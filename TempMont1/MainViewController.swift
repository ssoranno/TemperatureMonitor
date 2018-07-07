//
//  ViewController.swift
//  TempMont1
//
//  Created by Ryan Soranno on 6/8/18.
//  Copyright © 2018 Steven Soranno. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var DegreesLabel: UILabel!
    
    @IBOutlet weak var ErrorWarning: UILabel!
    
    @IBAction func UpdateButton(_ sender: Any) {
        updateTemp()
    }
    var temperature = 0 {
        didSet{
            DegreesLabel.text = "\(temperature)°"
        }
    }
    
    var er = ""{
        didSet{
            ErrorWarning.textColor = UIColor.red
            ErrorWarning.text = er
        }
    }
    
    let defaults = UserDefaults.standard
    
    /*var serverURL = "http://192.168.1.97"
    var greatestTemp = 75
    var leastTemp = 67
    */
    
    //let serverURL = defaults.objec
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperature = 0
        er = ""
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        //UIApplication.shared.applicationIconBadgeNumber = 0
        //print("hello")
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "URLName"), object: nil, queue: OperationQueue.main) { (notification) in
            let settingCon = notification.object as! SettingsViewController
            self.serverURL = settingCon.SURL.text!
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "greatestTemp"), object: nil, queue: OperationQueue.main) { (notification) in
            let settingCon = notification.object as! SettingsViewController
            self.greatestTemp = Int(settingCon.GreatestTemp.text!)!
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "leastTemp"), object: nil, queue: OperationQueue.main) { (notification) in
            let settingCon = notification.object as! SettingsViewController
            self.leastTemp = Int(settingCon.LeastTemp.text!)!
        }
        
        
        updateTemp()
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateTemp), userInfo: nil, repeats: true)
        
    }
    
    // Comment for git
    @objc func updateTemp()->Void{
        print("updated Temp")
        print("sURL: \(serverURL)")
        //let urlString = "http://192.168.1.97"
        var temp:Int = 0
        var err = ""
        let url = URL(string:serverURL)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do{
                let contents = try String(contentsOf: url!)
                temp = (self?.getTemp(contents: contents))!
                DispatchQueue.main.async {
                    self?.temperature = temp
                    self?.CheckTemp(temp: (self?.temperature)!)
                    self?.er = ""
                }
            } catch {
                print("contents could not be loaded")
                err = "Error: Server could be down"
                DispatchQueue.main.async {
                    self?.er = err
                    self?.view.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func getTemp(contents:String)->Int{
        let l = contents.count-2
        var index1 = 0
        var index2 = 0
        for i in 0...l{
            let num = contents.index(contents.startIndex, offsetBy: i)
            let num2 = contents.index(contents.startIndex, offsetBy: i+1)
            if(contents[num] == "e" && contents[num2] == ":"){
                index1 = i+14
            }
        }
        for i in index1...l+1 {
            let num = contents.index(contents.startIndex, offsetBy: i)
            if(contents[num] == "\0"){
                index2 = i
                break
            }
        }
        let start = contents.index(contents.startIndex, offsetBy: index1)
        let end = contents.index(contents.startIndex, offsetBy: index2)
        let range = start..<end
        let substr = contents[range]
        return Int(String(substr))!
    }
    
    func CheckTemp(temp:Int)->Void {
        let content = UNMutableNotificationContent()
        content.title = "Temperature Out of Range"
        content.body = "Temperature: \(temperature)"
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        if(temperature < leastTemp){
            self.view.backgroundColor = UIColor.blue
            let request = UNNotificationRequest(identifier: "TooCold", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else if(temperature > greatestTemp){
            self.view.backgroundColor = UIColor.red
            let request = UNNotificationRequest(identifier: "TooHot", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } else{
            self.view.backgroundColor = UIColor.green
        }
    }


}

