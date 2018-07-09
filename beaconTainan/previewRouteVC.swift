import UIKit

var roouteList = ["起點：現在在地下道外圍邊牆，請沿外圍邊牆追跡，向前直行。",
                  "請停下來注意前方機車與計程車出入，繼續直行 10公尺找到無障礙電梯口。",
                  "請循訊號聲向前找到電梯口。 找到電梯後，於手機按確認。",
                  "進入電梯後走到底，按鍵在前方右側，請按下 B one 進入人行地下道。",
                  "出電梯後請沿左側牆面追跡進入人行通道。進入通道後請左轉，沿左側牆面追跡30公尺抵達樓梯口。",
                  "請繼續直行15公尺，找到樓梯口後左轉。",
                  "請左轉進入電梯通道。",
                  "抵達電梯通道，請右轉向前找到電梯。進電梯後走到底，按鍵在前方左側，按下1樓回到地面層。",
                  "出電梯後，離開左側欄杆，直行20公尺後抵達路口，可沿著地面整排鐵製水溝蓋追跡。",
                  "請繼續直行10公尺後抵達路口。",
                  "請循聲走到斑馬線起點，確認雙腳踩在人行道與柏油路交界，於手機按確認。",
                  "請面對馬路等待綠燈通知後穿越中山路，路長20公尺。",
                  "請往前通過中山路，注意轉彎車流。",
                  "注意轉彎車，請盡速抵達人行道，循著訊號聲找到南站公車服務亭。",
                  "面對公車亭左轉，繞著公車亭追跡找到服務員窗口。",
                  "抵達終點服務亭。請停下向站內人員尋求協助。搭乘2號、19號公車，於無障礙福利之家下車。"
                  ]

class previewRouteVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var routeTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeTableview.delegate = self
        routeTableview.dataSource = self
        routeTableview.rowHeight = UITableViewAutomaticDimension
        routeTableview.estimatedRowHeight = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roouteList.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let readData = roouteList[indexPath.row] as! String
        
        cell.textLabel?.font = UIFont(name:"Avenir", size:20)
        
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.text = readData
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 150.0;//Choose your custom row height
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
