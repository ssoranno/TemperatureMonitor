//
//  ViewController.swift
//  TempMont1
//
//  Created by Ryan Soranno on 6/8/18.
//  Copyright © 2018 Steven Soranno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            ErrorWarning.text = er
        }
    }
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperature = 0
        er = ""
        
        updateTemp()
        
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateTemp), userInfo: nil, repeats: true)
        
        //performSelector(inBackground: #selector(updateTemp), with: nil)
        //performSelector(onMainThread: #selector(CheckTemp), with: nil, waitUntilDone: true)
        //updateTemp()
        /*let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response,error) in
            let dataStr = NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as! String
            print(dataStr)
        })
        task.resume()*/
    }
    
    /*@objc func runProcess()->Void {
        performSelector(inBackground: #selector(updateTemp), with: nil)
        //performSelector(onMainThread: #selector(CheckTemp), with: temp, waitUntilDone: false)
    }*/
    
    @objc func updateTemp()->Void{
        let urlString = "http://192.168.1.97"
        var temp:Int = 0
        var err = ""
        let url = URL(string:urlString)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do{
                let contents = try String(contentsOf: url!)
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
                temp = Int(String(substr))!
                //return temp
            } catch {
                print("contents could not be loaded")
                err = "Error: Server could be down"
            }
            DispatchQueue.main.async {
                self?.temperature = temp
                self?.er = err
                self?.CheckTemp(temp: (self?.temperature)!)
            }
        }
    }
    
    func CheckTemp(temp:Int)->Void {
        if(temperature < 67){
            self.view.backgroundColor = UIColor.blue
        } else if(temperature > 75){
            self.view.backgroundColor = UIColor.red
        } else{
            self.view.backgroundColor = UIColor.green
        }
    }


}
