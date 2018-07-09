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

var boolTraffic = [130: false, 137: false, 139:false]
var boolBeacons = [1201: false, 6001: false, 1: false, 2: false, 3: false, 4: false, 5: false, 6.3: false, 6.1: false, 7: false, 8: false, 9: false, 11: false, 12: false, 13: false, 14: false]
var realtimeBeacons = [1201: -9999, 6001: -9999, 1: -9999, 2: -9999, 3: -9999, 4: -9999, 5: -9999, 6.3: -9999, 6.1: -9999, 7: -9999, 8: -9999, 9: -9999, 11: -9999, 12: -9999, 13: -9999, 14: -9999]

/* data */
var light = 0
var TTSspeed = 0.65
/* beaconNumber */
var num = 0.0
//var tainanBeacons = [1201: -9999, 15194: 3, 33749: 4]
var rssiBeacons = [1201: -9999, 6001: -9999, 1: -9999, 2: -85, 3: -85, 4: -85, 5: -100, 6.3: -97, 6.1: -85, 7: -90, 8: -85, 9: -90, 11: -100, 12: -95, 13: -90, 14: -90]
var messageBeacons = [1: "起點：現在在地下道外圍邊牆，請沿外圍邊牆追跡，向前直行。",
                      2: "請停下來注意前方機車與計程車出入，繼續直行 10公尺找到無障礙電梯口。",
                      3: "請循訊號聲向前找到電梯口。 找到電梯後，於手機按確認。",
                      3.7: "我已找到電梯口",
                      3.8: "進入電梯後走到底，按鍵在前方右側，請按下 B one 進入人行地下道。",
                      4: "出電梯後請沿左側牆面追跡進入人行通道。進入通道後請左轉，沿左側牆面追跡30公尺抵達樓梯口。",
                      5: "請繼續直行15公尺，找到樓梯口後左轉。",
                      6.3: "請左轉進入電梯通道。",
                      6.1: "抵達電梯通道，請右轉向前找到電梯。進電梯後走到底，按鍵在前方左側，按下1樓回到地面層。",
                      7: "出電梯後，離開左側欄杆，請沿著左側整排鐵製水溝蓋追跡，直行20公尺後抵達路口。",
                      8: "請繼續直行10公尺後抵達路口。",
                      9: "請循聲走到斑馬線起點，確認雙腳踩在人行道與柏油路交界，於手機按確認。",
                      9.7: "我已站在斑馬線起點",
                      9.8: "請面對馬路等待綠燈通知後穿越中山路，路長20公尺。",
                      9.9: "請往前通過中山路，注意轉彎車流。",
                      11: "注意轉彎車，請盡速抵達人行道，循著訊號聲找到南站公車服務亭。",
                      11.7: "我已找到南站公車服務亭",
                      11.8: "面對公車亭左轉，繞著公車亭追跡找到服務員窗口。",
                      12: "抵達終點服務亭。請停下向站內人員尋求協助。搭乘2號、19號公車，於無障礙福利之家下車。",
                      13: "測試1",
                      14: "測試2",
                      14.7: "測試2互動訊息",
                      14.8: "測試2結束",
                    ] as [Double : Any]
var trafficlightString1 = "綠燈"
var trafficlightString2 = "秒，"

/* timer */
var isTimerRunning = false
var second39 = 39
var second37 = 37
var second30 = 30
/* tts */
let filetts = "file.txt" //this is the file. we will write to and read from it
var texttts = "0.6"

class startNavigationVC: UIViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var naviLabel: UILabel!
    
    @IBAction func exitButton(_ sender: UIButton) {
        print("Exit")
        num = 0
        for (key, _) in boolBeacons{
            boolBeacons[key] = false
        }
        for (key, _) in boolTraffic{
            boolTraffic[key] = false
        }
        
        print(boolBeacons)
    }
    
    @IBOutlet weak var actionbutton: UIButton!
    
    
    /* beacon */
    var beacons: [CLBeacon] = []
    var location : CLLocationManager!
    
    let beaconRegions = [CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidString)! as UUID, identifier: "IUI"),
                    CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidTainan)! as UUID, identifier: "Tainan"),
                    CLBeaconRegion(proximityUUID: NSUUID(uuidString: uuidBananaPi)! as UUID, identifier: "banana")]
    
    /* TTS */
    let syntesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    /* timer */
    var timer9 = Timer()
    var timer7 = Timer()
    var timer0 = Timer()
    
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
                utterance.rate = Float(TTSspeed)
                syntesizer.speak(utterance)
                print("PlayPause")
            }
            if event?.subtype == UIEventSubtype.remoteControlNextTrack {
                utterance = AVSpeechUtterance(string: (actionbutton.titleLabel?.text)!)
                utterance.rate = Float(TTSspeed)
                syntesizer.speak(utterance)
                print("222222222")
            }
            if event?.subtype == UIEventSubtype.remoteControlPreviousTrack {
                afterAlert()
                utterance = AVSpeechUtterance(string: naviLabel.text!)
                utterance.rate = Float(TTSspeed)
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
//        do{
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            do{
//                try AVAudioSession.sharedInstance().setActive(true)
//            }catch{
//            }
//        }catch{
//        }
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers])
        try! AVAudioSession.sharedInstance().setActive(true)
        
        /* start ranging beacon */
        beaconRegions.forEach(location!.startRangingBeacons)
        
        naviLabel.text = messageBeacons[1] as? String
        
//        actionbutton.isHidden = true
        actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
        actionbutton.isAccessibilityElement = true
        actionbutton.accessibilityTraits = UIAccessibilityTraitButton
        
        
//        startNavigationVC.accessibilityElementsHidden(false)
        /* voice over */
//        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, naviLabel)
//        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, naviLabel)
        /* tts */
//        let notificationName = Notification.Name("GetUpdateNoti")
//        NotificationCenter.default.addObserver(self, selector: #selector(getUpdateNoti(noti:)), name: notificationName, object: nil)
//        var myDict: NSDictionary?
//        if let path = Bundle.main.path(forResource: "List", ofType: "plist") {
//            myDict = NSDictionary(contentsOfFile: path)
//        }
//        print(myDict)
//        TTSspeed = myDict!["tts"] as! Double
//
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(filetts)
            //reading
            do {
                texttts = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        TTSspeed = Double(texttts)!
        print(TTSspeed)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        beaconRegions.forEach(location!.stopRangingBeacons)
        syntesizer.stopSpeaking(at: .immediate)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for (key, _) in boolBeacons{
            boolBeacons[key] = false
        }
        for (key, _) in boolTraffic{
            boolTraffic[key] = false
        }
        num = 0
        naviLabel.text = messageBeacons[1] as? String
        print(boolBeacons)
        isTimerRunning = false
        timer9.invalidate()
        second39 = 39
        timer7.invalidate()
        second37 = 37
        timer0.invalidate()
        second30 = 30
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beacon in beacons {
            print("!!!!!!!  locationManager  !!!!!!!")
            
            /* major number to key number */
//            if beacon.major == 33749 {
//                print("test 4 : " + String(beacon.rssi))
//                num = 400
//            }
//            if beacon.major == 15194 {
//                print("test 3: " + String(beacon.rssi))
//                num = 300
//            }
            
            /* */
            switch beacon.major {
//            case 1: num = 1
            case 2: num = 2
            case 3: num = 3
            case 4: num = 4
            case 5: num = 5
            case 63: num = 6.3
            case 61: num = 6.1
            case 7: num = 7
            case 8: num = 8
            case 9: num = 9
            case 10: num = 10
            case 11: num = 11
            case 12: num = 12
            case 13: num = 13
            case 14: num = 14
            /*
            case 5714: num = 1
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
            */
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
                            utterance.rate = Float(TTSspeed)
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
            }
            
            /* 處理不穩定訊號 */
//            var num = beacon.major.intValue
            if (beacon.rssi != 0){
                realtimeBeacons[num] = beacon.rssi
            }
            realtimeBeacons[6.3] = realtimeBeacons[6.1]
            
            /* 紅綠燈 */
            if beacon.major == 139 {
                var Ltext = trafficlightString1
                Ltext.append(String(second39))
                Ltext.append(trafficlightString2)
                Ltext.append((messageBeacons[9.9] as? String)!)
                naviLabel.text = Ltext
                TTS(key: beacon.major)
                if isTimerRunning == false {
                    runTimer()
                }
            }
            if beacon.major == 137 {
                var Ltext = trafficlightString1
                Ltext.append(String(second37))
                Ltext.append(trafficlightString2)
                Ltext.append((messageBeacons[9.9] as? String)!)
                naviLabel.text = Ltext
                TTS(key: beacon.major)
                if isTimerRunning == false {
                    runTimer2()
                }
            }
            if beacon.major == 130 {
                var Ltext = trafficlightString1
                Ltext.append(String(second30))
                Ltext.append(trafficlightString2)
                Ltext.append((messageBeacons[9.9] as? String)!)
                naviLabel.text = Ltext
                TTS(key: beacon.major)
                if isTimerRunning == false {
                    runTimer3()
                }
            }

        }
//        print(tainanBeacons.keysSortedByValue(isOrderedBefore: >))
//        print("3 " + String(describing: tainanBeacons[15194]))
//        print("4 " + String(describing: tainanBeacons[33749]))
//        print(realtimeBeacons.keysSortedByValue(isOrderedBefore: >).first)
//        print(boolBeacons)
//        print(realtimeBeacons)
//        print(rssiBeacons)
        
//        calculateRSSI()
        
        changeNaviMessage(key: num)
        print(num)
        
    }
    
    func TTS(key: NSNumber){
        let KEY = Int(key)
        if boolTraffic[KEY] == false{
            utterance = AVSpeechUtterance(string: naviLabel.text!)
            utterance.rate = Float(TTSspeed)
            syntesizer.speak(utterance)
            boolTraffic[KEY] = true
        }
    }
    
    func runTimer() {
        timer9 = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    func runTimer2() {
        timer7 = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer2)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    func runTimer3() {
        timer0 = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer3)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        if second39 != 0{
            second39 -= 1
        } else {
            isTimerRunning = false
            timer9.invalidate()
            second39 = 39
        }
    }
    @objc func updateTimer2() {
        if second37 != 0{
            second37 -= 1
        } else {
            isTimerRunning = false
            timer7.invalidate()
            second37 = 37
        }
    }
    @objc func updateTimer3() {
        if second30 != 0{
            second30 -= 1
        } else {
            isTimerRunning = false
            timer0.invalidate()
            second30 = 30
        }
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
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[2] as? String
                boolBeacons[3] = false
                boolBeacons[4] = false
                boolBeacons[5] = false
                boolBeacons[6.3] = false
                boolBeacons[6.1] = false
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 3:
                trafficAlert(bnum: 3)
                naviLabel.text = messageBeacons[3] as? String
                boolBeacons[4] = false
                boolBeacons[5] = false
                boolBeacons[6.3] = false
                boolBeacons[6.1] = false
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 4:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[4] as? String
                boolBeacons[5] = false
                boolBeacons[6.3] = false
                boolBeacons[6.1] = false
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 5:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[5] as? String
                boolBeacons[6.3] = false
                boolBeacons[6.1] = false
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 6.3:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[6.3] as? String
                boolBeacons[6.1] = false
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 6.1:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[6.1] as? String
                boolBeacons[7] = false
                boolBeacons[8] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 7:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[7] as? String
                boolBeacons[7] = false
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 8:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[8] as? String
                boolBeacons[9] = false
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 9:
                trafficAlert(bnum: 9)
                naviLabel.text = messageBeacons[9] as? String
                boolBeacons[11] = false
                boolBeacons[12] = false
            case 11:
                trafficAlert(bnum: 11)
                timer9.invalidate()
                timer7.invalidate()
                timer0.invalidate()
                naviLabel.text = messageBeacons[11] as? String
                boolBeacons[12] = false
            case 12:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[12] as? String
            case 13:
//                actionbutton.isHidden = true
                actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
                naviLabel.text = messageBeacons[13] as? String
            case 14:
                trafficAlert(bnum: 14)
                naviLabel.text = messageBeacons[14] as? String
                
            default: break
            }
            utterance = AVSpeechUtterance(string: naviLabel.text!)
            utterance.rate = Float(TTSspeed)
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
        if bnum == 9 {
            actnum = 9.7
            actionbutton.tag = 9
        }
        if bnum == 11 {
            actnum = 11.7
            actionbutton.tag = 11
        }
        if bnum == 14 {
            actnum = 14.7
            actionbutton.tag = 14
        }
        
//        actionbutton.isHidden = false
        actionbutton.frame = CGRect(x:0, y:543, width:375, height:124)
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil)
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
//        actionbutton.isHidden = true
        actionbutton.frame = CGRect(x:0, y:667, width:375, height:124)
        
        var actnum = 0.0
        if actionbutton.tag == 3 {
            actnum = 3.8
        }
        if actionbutton.tag == 9 {
            actnum = 9.8
        }
        if actionbutton.tag == 11 {
            actnum = 11.8
        }
        if actionbutton.tag == 14 {
            actnum = 14.8
        }
        naviLabel.text = messageBeacons[actnum] as? String
        utterance = AVSpeechUtterance(string: naviLabel.text!)
        utterance.rate = Float(TTSspeed)
//        syntesizer.speak(utterance)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            trafficlightBool = true
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    @objc func getUpdateNoti(noti:Notification) {
//        //接收編輯頁面回傳的資訊
//        TTSspeed = Double(noti.userInfo!["PASS"] as! Float)
//        print("\(noti.userInfo!["PASS"] )")
//
//    }
    
    
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

