//
//  startVC.swift
//  beaconTainan
//
//  Created by AllisonC on 2018/6/29.
//  Copyright © 2018年 AllisonC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import AVFoundation
import MediaPlayer

let uuidString   = "2A782241-52F4-4194-BF93-F7DE85F0D38C"
let uuidTainan   = "B01BCFC0-8F4B-11E5-A837-0821A8FF9A66"
let uuidBananaPi = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E1"
let identifier   = "IUI"

var trafficlightBool = false
var lightBool = false

var boolBeacons = [1201: false, 6001: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6.3: false, 6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
var realtimeBeacons = [1201: -9999, 6001: -9999, 1: -9999, 2: -9999, 3: -9999, 4: -9999, 5: -9999, 6.3: -9999, 6.1: -9999, 7: -9999, 8: -9999, 9.2: -9999, 9.1: -9999, 10: -9999, 11: -9999, 12: -9999, 13: -9999, 14: -9999]

/* data */
var light = 0
/* beaconNumber */
var num = 0.0
//var tainanBeacons = [1201: -9999, 15194: 3, 33749: 4]
var rssiBeacons = [1201: -9999, 6001: -9999, 1: -9999, 2: -85, 3: -85, 4: -85, 5: -100, 6.3: -97, 6.1: -85, 7: -90, 8: -85, 9.2: -84, 9.1: -73, 10: -90, 11: -100, 12: -95, 13: -90, 14: -90]
var messageBeacons = [1: "起點：地下道出入口，確認地下道在三點鐘方向，請沿地下道邊牆追跡，向前直行。",
                      2: "脫離地下道邊牆，直行 10公尺找到無障礙電梯口。穿越時請注意機車與計程車出入。",
                      3: "請循著訊號聲向前找到電梯口。電梯口位於兩側鐵欄杆中間，按鍵在門框右側。",
                      3.7: "我已找到電梯口",
                      3.8: " ",
                      4: "出電梯後請右轉，進入人行通道，進入通道後請沿右側牆面追跡，直行30公尺抵達樓梯口。",
                      5: "請繼續直行15公尺，找到樓梯口後左轉。",
                      6.3: "請左轉進入電梯通道。",
                      6.1: "抵達電梯通道，請右轉向前找到電梯。按鍵在門框右側。",
                      7: "出電梯後，脫離左側欄杆，請沿著左側地面鐵製水溝蓋追跡，20公尺後抵達路口。",
                      8: "請繼續直行10公尺後抵達路口。",
                      9.2: "請向前找到路口號誌桿，注意人行道落差。",
                      9.1: "請轉向讓號誌桿為3點鐘方向，並確認9點鐘方向為騎樓邊牆，沿著邊牆向前至斑馬線起點。",
                      10: "請循聲找到斑馬線起點，將身體背面對齊騎樓邊牆，面對馬路等待綠燈通知後前進。",
                      10.7: "我已將身體背面對齊騎樓邊牆",
                      10.8: "請聽取對向第一陣車流聲後，穿越中山路，路長20公尺。",
                      10.9: "請往前通過中山路，注意轉彎車流。",
                      11: "注意轉彎車，請盡速抵達人行道，循著訊號聲找到南站公車服務亭。",
                      11.7: "已找到南站公車服務亭",
                      11.8: "請以身體右側沿著公車服務亭向前繞行找到服務員窗口。",
                      12: "抵達終點服務亭。請向站務人員尋求協助搭乘2號、19號公車，於無障礙福利之家下車。",
                      13: "抵達終點服務亭。請向站務人員尋求協助搭乘2號、19號公車，於無障礙福利之家下車。",
                      14: "抵達終點服務亭。請向站務人員尋求協助搭乘2號、19號公車，於無障礙福利之家下車。"
    ] as [Double : Any]

var trafficlightString1 = "綠燈"
var trafficlightString2 = "秒，"


class startVC:  UIViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    
    
    @IBOutlet weak var naviLabel: UILabel!
    
    @IBAction func exitButton(_ sender: UIButton) {
        
        print("Exit")
        print(boolBeacons)
    }
    
    @IBOutlet weak var actionbutton: UIButton!
    
    /* beacon */
    var beacons: [CLBeacon] = []
    var location : CLLocationManager!
    
    let beaconRegions = [CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidString)! as UUID, identifier: "IUI"),
                         CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidTainan)! as UUID, identifier: "Tainan"),
                         CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidBananaPi)! as UUID, identifier: "banana")]
    
    
    let syntesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    var timer: Timer?
    
    /* 耳機 */
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if (event?.type == UIEventType.remoteControl) {
            print(event?.subtype)
            if event?.subtype == UIEventSubtype.remoteControlTogglePlayPause {
                
                utterance = AVSpeechUtterance(string: naviLabel.text!)
                utterance.rate = 0.7
                syntesizer.speak(utterance)
                
                print("PlayPause")
            }
            if event?.subtype == UIEventSubtype.remoteControlNextTrack {
                afterAlert()
                utterance = AVSpeechUtterance(string: naviLabel.text!)
                utterance.rate = 0.7
                syntesizer.speak(utterance)
                print("222222222")
            }
            if event?.subtype == UIEventSubtype.remoteControlPreviousTrack {
                //
                utterance = AVSpeechUtterance(string: (actionbutton.titleLabel?.text)!)
                utterance.rate = 0.7
                syntesizer.speak(utterance)
                print("333333333")
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Location */
        location = CLLocationManager()
        location.delegate = self
        
        /* beacon */
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                location.requestAlwaysAuthorization()
            }
        }
        
        /* AVSpeech */
        syntesizer.delegate = self
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            do{
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
            }
        }catch{
        }
        
        /* start ranging beacon */
        beaconRegions.forEach(location!.startRangingBeacons)
        
        naviLabel.text = messageBeacons[1] as? String
        
        actionbutton.isHidden = true
        
        /* voice over */
        //        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, naviLabel)
        //        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, naviLabel)
        
        /* */
        //        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient, with: AVAudioSessionCategoryOptions.allowBluetooth)
        //        try?  AVAudioSession.sharedInstance().setActive(true)
        //
        //        if let path = Bundle.main.path(forResource: "LadyGaga-MillionReasons", ofType: "mp3") {
        //            let url = URL(string:path)
        //            self.audioPlayer = try? AVAudioPlayer(contentsOf: url!)
        //            self.audioPlayer?.prepareToPlay()
        //        }
        //        self.becomeFirstResponder()
        //        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        //        var rcc = MPRemoteCommandCenter.shared()
        //        var pauseCommand: MPRemoteCommand? = rcc.pauseCommand
        //        pauseCommand?.isEnabled = true
        //        pauseCommand?.addTarget(self, action: #selector(self.playOrPauseEvent(_:)))
        //        var playCommand: MPRemoteCommand? = rcc.playCommand
        //        playCommand?.isEnabled = true
        //        playCommand?.addTarget(self, action: #selector(self.playOrPauseEvent(_:)))
        //        var nextCommand: MPRemoteCommand? = rcc.nextTrackCommand
        //        nextCommand?.isEnabled = true
        //        nextCommand?.addTarget(self, action: #selector(self.nextCommandEvent(_:)))
        
        
    }
    //    @objc func playOrPauseEvent(_: AnyObject){
    //        utterance = AVSpeechUtterance(string: naviLabel.text!)
    //        utterance.rate = 0.7
    //        syntesizer.speak(utterance)
    //    }
    //    @objc func nextCommandEvent(_: AnyObject){
    //        self.exitButton(yourButton)
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        beaconRegions.forEach(location!.stopRangingBeacons)
        syntesizer.stopSpeaking(at: .immediate)
    }
    override func viewDidDisappear(_ animated: Bool) {
        for (key, _) in boolBeacons{
            boolBeacons[key] = false
        }
        
        naviLabel.text = messageBeacons[1] as? String
        print(boolBeacons)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beacon in beacons {
            print("!!!!!!!  locationManager  !!!!!!!")
            
            /* major number to key number */
            if beacon.major == 33749 {
                print("test 4 : " + String(beacon.rssi))
                num = 13
            }
            if beacon.major == 15194 {
                print("test 3: " + String(beacon.rssi))
                num = 14
            }
            
            /* */
            switch beacon.major {
            //            case 5714: num = 1
            case 20293: num = 2
            case 29062: num = 3
            case 13148: num = 4
            case 1278: num = 5
            case 41988: num = 6.1
            case 14500: num = 7
            case 59957: num = 8
            case 45895: num = 9.1
            case 56235: num = 10
            case 14863: num = 11
            case 47739: num = 12
            default: break
            }
            
            /* 紅綠燈 1201 or 6001 */
            if beacon.major == 6001 {
                light = Int(beacon.minor)
                if trafficlightBool == true {
                    if (light/256) == 1 {
                        print("綠燈")
                        print(light%256)
                        /* 綠燈 */
                        if lightBool == true {
                            var Ltext = trafficlightString1
                            Ltext.append(String(light%256))
                            Ltext.append(trafficlightString2)
                            Ltext.append((messageBeacons[10.9] as? String)!)
                            naviLabel.text = Ltext
                            utterance = AVSpeechUtterance(string: Ltext)
                            utterance.rate = 0.7
                            //                            syntesizer.speak(utterance)
                            //                            trafficlightBool = false
                        }
                        /* 最大秒數 */
                        if (light%256) == 40 {
                            syntesizer.speak(utterance)
                        }
                        if (light%256) == 1 {
                            trafficlightBool = false
                            lightBool = false
                        }
                    }
                    if (light/256) == 2 {
                        /* 紅燈 */
                        print(light%256)
                        lightBool = true
                    }
                }
                print(beacon.minor)
            }
            
            /* 處理不穩定訊號 */
            //            var num = beacon.major.intValue
            if (beacon.rssi != 0){
                realtimeBeacons[num] = beacon.rssi
            }
            realtimeBeacons[6.3] = realtimeBeacons[6.1]
            realtimeBeacons[9.2] = realtimeBeacons[9.1]
            
            
            
        }
        //        print(tainanBeacons.keysSortedByValue(isOrderedBefore: >))
        //        print("3 " + String(describing: tainanBeacons[15194]))
        //        print("4 " + String(describing: tainanBeacons[33749]))
        //        print(realtimeBeacons.keysSortedByValue(isOrderedBefore: >).first)
        //        print(boolBeacons)
        //        print(realtimeBeacons)
        //        print(rssiBeacons)
        
        calculateRSSI()
        
    }
    
    @objc func timerEvent(_ timer: Timer?) {
        /* stop timer */
        timer?.invalidate()
    }
    
    func calculateRSSI(){
        print("calculateRSSI")
        for key in realtimeBeacons.keysSortedByValue(isOrderedBefore: >) {
            
            if realtimeBeacons[key]! > rssiBeacons[key]!{
                print(key)
                changeNaviMessage(key: key)
                break
                
            }
        }
    }
    
    func changeNaviMessage(key: Double){
        if boolBeacons[key] == false {
            switch key {
            case 2:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[2] as? String
                //                for index in 1...5 {
                //                    boolBeacons[index] = false
                //                }
                boolBeacons = [3: false, 4: false, 5: false, 6.3: false, 6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 3:
                trafficAlert(bnum: 3)
                naviLabel.text = messageBeacons[3] as? String
                boolBeacons = [4: false, 5: false, 6.3: false, 6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 4:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[4] as? String
                boolBeacons = [5: false, 6.3: false, 6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 5:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[5] as? String
                boolBeacons = [6.3: false, 6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 6.3:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[6.3] as? String
                boolBeacons = [6.1: false, 7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 6.1:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[6.1] as? String
                boolBeacons = [7: false, 8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 7:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[7] as? String
                boolBeacons = [8: false, 9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 8:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[8] as? String
                boolBeacons = [9.2: false, 9.1: false, 10: false, 11: false, 12: false]
            case 9.2:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[9.2] as? String
                boolBeacons = [9.1: false, 10: false, 11: false, 12: false]
            case 9.1:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[9.1] as? String
                boolBeacons = [10: false, 11: false, 12: false]
            case 10.0:
                trafficAlert(bnum: 10)
                naviLabel.text = messageBeacons[10.0] as? String
                boolBeacons = [11: false, 12: false]
            case 11.0:
                trafficAlert(bnum: 11)
                naviLabel.text = messageBeacons[11.0] as? String
                boolBeacons = [12: false]
            case 12:
                actionbutton.isHidden = true
                naviLabel.text = messageBeacons[12] as? String
                
            default: break
            }
            
            utterance = AVSpeechUtterance(string: naviLabel.text!)
            utterance.rate = 0.7
            syntesizer.speak(utterance)
            boolBeacons[key] = true
        }
    }
    
    
    func trafficAlert(bnum: NSNumber){
        
        var actnum = 0.0
        if bnum == 3 {
            actnum = 3.7
            actionbutton.tag = 3
        }
        if bnum == 10 {
            actnum = 10.7
            actionbutton.tag = 10
        }
        if bnum == 11 {
            actnum = 11.7
            actionbutton.tag = 11
        }
        
        actionbutton.isHidden = false
        actionbutton.setTitle(messageBeacons[actnum] as? String, for: .normal)
        actionbutton.addTarget(
            self,
            action: #selector(afterAlert),
            for: .touchUpInside)
        /*
         DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
         let alert = UIAlertController(title: "我已將身體背面對齊騎樓邊牆", message: "", preferredStyle: .alert)
         let action = UIAlertAction(title: "OK!", style: .default) { (UIAlertAction) in self.afterAlert() }
         alert.addAction(action)
         self.present(alert, animated: true, completion: nil)
         }
         */
    }
    
    
    @objc func afterAlert(){
        actionbutton.isHidden = true
        
        print(num)
        var actnum = 0.0
        if actionbutton.tag == 3 {
            actnum = 3.8
        }
        if actionbutton.tag == 10 {
            actnum = 10.8
        }
        if actionbutton.tag == 11 {
            actnum = 11.8
        }
        naviLabel.text = messageBeacons[actnum] as? String
        utterance = AVSpeechUtterance(string: naviLabel.text!)
        utterance.rate = 0.7
        //        syntesizer.speak(utterance)
        
        //        waitforlight()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            trafficlightBool = true
            
        })
    }
    
    
    func waitforlight(){
        if (light/256) == 1 {
            /* 綠燈 */
            if trafficlightBool == false {
                trafficlightBool = true
            } else {
                var Ltext = trafficlightString1
                Ltext.append(trafficlightString2)
                Ltext.append((messageBeacons[10.9] as? String)!)
                naviLabel.text = Ltext
                utterance = AVSpeechUtterance(string: messageBeacons[10.9] as! String)
                utterance.rate = 0.7
                syntesizer.speak(utterance)
            }
            
        }
        if (light/256) == 2 {
            /* 紅燈 */
            trafficlightBool = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*
     //開始monitor region後，呼叫此delegate函數
     func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
     //To check whether the user is already inside the boundary of a region
     //delivers the results to the location manager’s delegate "didDetermineState"
     manager.requestState(for: region)
     }
     
     //The location manager calls this method whenever there is a boundary transition for a region.
     func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
     if state == CLRegionState.inside{
     manager.startRangingBeacons(in: (region as! CLBeaconRegion))
     }else{
     manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
     }
     }
     //The location manager calls this method whenever there is a boundary transition for a region.
     func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
     
     if CLLocationManager.isRangingAvailable(){
     manager.startRangingBeacons(in: (region as! CLBeaconRegion))
     }else{
     print("不支援ranging")
     }
     if (beacons.count > 0){
     print("!!!!!!!!didEnterRegion!!!!!!!!")
     
     if beacons.first?.major == 33749 {
     BlindNaviBeacon.text = "4"
     naviMessage.text = "請在周圍搜尋號誌燈，碰到後長按胸針聆聽指示"
     print("enter4")
     }
     
     if beacons.first?.major == 15194 {
     BlindNaviBeacon.text = "3"
     naviMessage.text = "起點：健康中心，請面對馬路右轉，於，指南路，人行道上直行，15公尺後準備轉"
     print("enter3")
     }
     }
     }
     */
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
        //        view.backgroundColor = UIColor.white
        //        message.text = "byebye"
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}

/* sorting  */
extension Dictionary {
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sorted(by: isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sorted() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}

