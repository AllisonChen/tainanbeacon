//
//  ttsVC.swift
//  beaconTainan
//
//  Created by AllisonC on 2018/7/7.
//  Copyright © 2018年 AllisonC. All rights reserved.
//

import UIKit

let file = "file.txt" //this is the file. we will write to and read from it
var text = "0.6"

class ttsVC: UIViewController {
    
    @IBOutlet weak var tts: UISlider!
    var TTSspeed = 0.65
    @IBAction func ttsslider(_ sender: UISlider) {
        TTSspeed = Double(sender.value)
        Label.text = String(sender.value)
//        let notificationName = Notification.Name("GetUpdateNoti")
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS":sender.value])
//        writePlist(namePlist: "List", key: "tts", data: TTSspeed as AnyObject)
        text = String(sender.value)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                text = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Text: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        var data = readPlist(namePlist: "List", key: "tts")
//        tts.value = data as! Float
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
            //reading
            do {
                text = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        
        tts.value = Float(text)!
        Label.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func readPlist(namePlist: String, key: String) -> AnyObject{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("List"+".plist")
        
        var output = false
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            output = dict.object(forKey: key)!  as! Bool
        }else{
            if let privPath = Bundle.main.path(forResource: "List", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    output = (dict.object(forKey: key) != nil)
                }else{
                    output = false
                    print("error_read")
                }
            }else{
                output = false
                print("error_read")
            }
        }
        return output as AnyObject
    }
    
    func writePlist(namePlist: String, key: String, data: AnyObject){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent("List"+".plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.setObject(data, forKey: key as NSCopying)
            if dict.write(toFile: path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = Bundle.main.path(forResource: "List", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.setObject(data, forKey: key as NSCopying)
                    if dict.write(toFile: path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
