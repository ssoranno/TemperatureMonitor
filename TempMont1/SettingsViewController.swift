//
//  SettingsViewController.swift
//  TempMont1
//
//  Created by Ryan Soranno on 6/13/18.
//  Copyright © 2018 Steven Soranno. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var controller: MainViewController? = nil
    
    @IBOutlet weak var SURL: UITextField!
    
    @IBOutlet weak var GreatestTemp: UITextField!
    
    @IBOutlet weak var LeastTemp: UITextField!
    
    @IBAction func SubmitURLButton(_ sender: Any) {
        //let vc = window?.rootViewController as? MainViewController
        //controller = MainViewController()
        //vc?.serverURL = SURL.text!
        //print(vc?.serverURL)
        //controller?.serverURL = SURL.text!
        //let vc = MainViewController()
        //vc.serverURL = SURL.text!
        //navigationController?.pushViewController(vc, animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "URLName"), object: self)
        
    }
    
    @IBAction func SubmitRangeButton(_ sender: Any) {
        //let vc = window?.rootViewController as? MainViewController
        //vc?.greatestTemp = Int(GreatestTemp.text!)!
        //vc?.leastTemp = Int(LeastTemp.text!)!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MainViewController{
            print("omg")
            vc.serverURL = SURL.text!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
