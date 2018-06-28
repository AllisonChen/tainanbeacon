//import UIKit
//import CoreLocation
//import CoreBluetooth
//import AVFoundation
//
//let uuidString   = "2A782241-52F4-4194-BF93-F7DE85F0D38C"
//let uuidTainan   = "B01BCFC0-8F4B-11E5-A837-0821A8FF9A66"
//let uuidBananaPi = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E1"
//let identifier   = "IUI"
//
//
//class ViewController: UIViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
//    
//    @IBOutlet weak var BlindNaviBeacon: UILabel!
//    @IBOutlet weak var naviMessage: UILabel!
//
//    /* beacon */
//    var beacons: [CLBeacon] = []
//    var location : CLLocationManager!
//    
//    let beaconRegions = [CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidString)! as UUID, identifier: "IUI"),
//                         CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidTainan)! as UUID, identifier: "Tainan"),
//                         CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidBananaPi)! as UUID, identifier: "banana")]
//    
//    
//    let syntesizer = AVSpeechSynthesizer()
//    var utterance = AVSpeechUtterance()
//    
//    var timer: Timer?
//    var realtimeBlindNaviBeacon: NSNumber = 0.0
//    var nowBlindNaviBeacon: NSNumber = 99999999.0
//    
//    /*  */
//    var tainanBeacons = [1201: 9999, 15194: 3, 33749: 4]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        
//        
//        /* Location */
//        location = CLLocationManager()
//        location.delegate = self
//        
//        /* beacon */
//        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
//            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
//                location.requestAlwaysAuthorization()
//            }
//        }
//        
//        /* AVSpeech */
//        syntesizer.delegate = self
//        do{
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            do{
//                try AVAudioSession.sharedInstance().setActive(true)
//            }catch{
//            }
//        }catch{
//        }
//
//        /* start ranging beacon */
//        beaconRegions.forEach(location!.startRangingBeacons)
//        
//    }
// 
//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        
//        for beacon in beacons {
//            //            if let nearstBeacon = beacons.first{
//            print(tainanBeacons[1201])
//            print("!!!!!!!!!!!!!!!!!!!!HERE!!!!!!!!!!!!!!!!!!!")
//            print(beacons.first)
//            
//            realtimeBlindNaviBeacon = (beacons.first?.major)!
//            
//            /* 處理不穩定訊號 */
//            var num = beacon.major.intValue
//            if (beacon.rssi != 0){
//                tainanBeacons[num] = beacon.rssi
//            }
//            
//            
//            
//            if beacon.major == 1201{
//                if (beacon.rssi) > -60 && (beacon.rssi) < -50  {
//                    let num = beacon.minor.intValue
//                    if (num/256) == 1 {
//                        naviMessage.text = "綠燈：" + String(num%256)
//                        naviMessage.backgroundColor = UIColor.green
//                    }
//                    if (num/256) == 2 {
//                        naviMessage.text = "紅燈：" + String(num%256)
//                        naviMessage.backgroundColor = UIColor.red
//                    }
//                } else {
//                    naviMessage.text = " "
//                }
//                
//            } else {
//                
//                if (beacon.rssi) > -70 {
//                    naviMessage.backgroundColor = UIColor.gray
//                    if realtimeBlindNaviBeacon == nowBlindNaviBeacon {
//                        if syntesizer.isSpeaking {
////                            syntesizer.stopSpeaking(at: .immediate)
//                            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.changeNaviMessage), userInfo: nil, repeats: false)
//                        }
////                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.changeNaviMessage), userInfo: nil, repeats: false)
////                        changeNaviMessage()
//                    } else {
//                        nowBlindNaviBeacon = realtimeBlindNaviBeacon
//                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
////                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerEvent(_:)), userInfo: nil, repeats: false)
////                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ViewController.changeNaviMessage), userInfo: nil, repeats: false)
//                        changeNaviMessage()
//                    }
//                    
//                }
//            }
//        }
//  
//
//        
//    }
//    
//    @objc func timerEvent(_ timer: Timer?) {
//        changeNaviMessage()
//        /* stop timer */
//        timer?.invalidate()
//    }
//
//    @objc func changeNaviMessage(){
//        switch nowBlindNaviBeacon {
//        case 15194:
//            BlindNaviBeacon.text = "3"
//            naviMessage.text = "起點：健康中心，請面對馬路右轉，於，指南路，人行道上直行，15公尺後準備左轉"
//            
//            print("3")
//        case 33749:
//            BlindNaviBeacon.text = "4"
//            naviMessage.text = "請在周圍搜尋號誌燈，碰到後長按胸針聆聽指示"
//            print("4")
//            
//        default: break
//            
//        }
//        
//        utterance = AVSpeechUtterance(string: naviMessage.text!)
//        utterance.rate = 0.7
//        syntesizer.speak(utterance)
//        
//        
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        
//    }
///*
//    //開始monitor region後，呼叫此delegate函數
//    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//        //To check whether the user is already inside the boundary of a region
//        //delivers the results to the location manager’s delegate "didDetermineState"
//        manager.requestState(for: region)
//    }
//    
//    //The location manager calls this method whenever there is a boundary transition for a region.
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        if state == CLRegionState.inside{
//            manager.startRangingBeacons(in: (region as! CLBeaconRegion))
//        }else{
//            manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
//        }
//    }
//    //The location manager calls this method whenever there is a boundary transition for a region.
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        
//        if CLLocationManager.isRangingAvailable(){
//            manager.startRangingBeacons(in: (region as! CLBeaconRegion))
//        }else{
//            print("不支援ranging")
//        }
//        if (beacons.count > 0){
//            print("!!!!!!!!didEnterRegion!!!!!!!!")
//                
//            if beacons.first?.major == 33749 {
//                BlindNaviBeacon.text = "4"
//                naviMessage.text = "請在周圍搜尋號誌燈，碰到後長按胸針聆聽指示"
//                print("enter4")
//            }
//            
//            if beacons.first?.major == 15194 {
//                BlindNaviBeacon.text = "3"
//                naviMessage.text = "起點：健康中心，請面對馬路右轉，於，指南路，人行道上直行，15公尺後準備轉"
//                print("enter3")
//            }
//        }
//    }
// 
//    //The location manager calls this method whenever there is a boundary transition for a region.
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
////        view.backgroundColor = UIColor.white
////        message.text = "byebye"
//    }
//*/
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        print(error.localizedDescription)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
//        print(error.localizedDescription)
//    }
//
//}
//
