import UIKit

var roouteList = ["起點：地下道出入口，確認地下道在三點鐘方向，請沿地下道邊牆追跡，向前直行。",
                  "脫離地下道邊牆，直行 10公尺找到無障礙電梯口。穿越時請注意機車與計程車出入。",
                  "請循著訊號聲向前找到電梯口。電梯口位於兩側鐵欄杆中間，按鍵在門框右側。",
                  "出電梯後請右轉，進入人行通道，進入通道後請沿右側牆面追跡，直行30公尺抵達樓梯口。",
                  "請繼續直行15公尺，找到樓梯口後左轉。",
                  "請左轉進入電梯通道。",
                  "抵達電梯通道，請右轉向前找到電梯。按鍵在門框右側。",
                  "出電梯後，脫離左側欄杆，請沿著左側地面鐵製水溝蓋追跡，20公尺後抵達路口。",
                  "請繼續直行10公尺後抵達路口。",
                  "請向前找到路口號誌桿，注意人行道落差。",
                  "請轉向讓號誌桿為3點鐘方向，並確認9點鐘方向為騎樓邊牆，沿著邊牆向前至斑馬線起點。",
                  "請循聲抵達斑馬線起點，將身體背面對齊騎樓邊牆，面對馬路等待綠燈通知後前進。",
                  "注意轉彎車，請盡速抵達人行道，循著訊號聲找到南站公車服務亭。",
                  "抵達終點服務亭。請向站務人員尋求協助搭乘2號、19號公車，於無障礙福利之家下車。"
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
