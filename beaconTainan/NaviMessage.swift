import Foundation
/*
class BeaconModel: NSObject, Decodable{
    
    let ID: String
    let UUID: String
    let Major: String
    let minor: String
//    let coordinate: CLLocationCoordinate2D
    let GPSlatitude: Int
    let GPSlongitude: Int
    
    init(ID: String, UUID: String, Major: String, minor: String, GPSlatitude: Int, GPSlongitude: Int ) {
        self.ID = ID
        self.UUID = UUID
        self.Major = Major
        self.minor = minor
        //        self.coordinate = coordinate
        self.GPSlatitude = GPSlatitude
        self.GPSlongitude = GPSlongitude
        
        super.init()
    }
    
}*/

fileprivate struct BlindNaviResponse: Decodable {
    struct Beacons: Decodable {
        var GPSlatitude: String
        var real_info: UserRealInfo
    }
    
    struct UserRealInfo: Decodable {
        var full_name: String
    }
    
 
    
    var id: Int
    var user: Beacons
}

//struct BlindNavi: Decodable {
//    var id: String
//    var username: String
//    var fullName: String
//    var reviewCount: Int
//    
//    init(from decoder: Decoder) throws {
//        let rawResponse = try BlindNaviResponse(from: decoder)
//        
//        // Now you can pick items that are important to your data model,
//        // conveniently decoded into a Swift structure
//        id = String(rawResponse.id)
//        username = rawResponse.user.user_name
//        fullName = rawResponse.user.real_info.full_name
//        reviewCount = rawResponse.reviews_count.first!.count
//        
//        
//    }
//}


//
//let url = Bundle.main.url(forResource: "beaconmap", withExtension:"json")
//let data = try? Data(contentsOf: url!)
//
//if let data = data {
//    do {
//        let movieArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
//        if let movieArray = movieArray {
//            for movieDic in movieArray {
//                print(movieDic)
//            }
//        }
//    }
//    catch {
//    }
//}

//
//class NaviMessage{
//    var fromBlindNavibeacon : NSNumber
//    var toBlindNavibeacon : NSNumber
//    var previousLocation : String
//    var nextLocation : String
//
//    init(fromBlindNavibeacon : NSNumber, toBlindNavibeacon : NSNumber, previousLocation : String, nextLocation : String) {
//        self.fromBlindNavibeacon = fromBlindNavibeacon
//        self.toBlindNavibeacon = toBlindNavibeacon
//        self.previousLocation = previousLocation
//        self.nextLocation = nextLocation
//    }
//}
/*
let decoder = JSONDecoder()
let encoder = JSONEncoder()

struct User: Codable {
    let userInfo : UserInfo
    
    struct UserInfo: Codable {
        let id : String
        let name : String
        let email : String
        let imageURLs : [String]
        let bodyShape: BodyShape
        let friends : [Friend]
    }
    
    struct Friend: Codable {
        let id: String
        let name: String
        let email: String?
        let bodyShape: BodyShape?
    }
    
    struct BodyShape: Codable {
        let weight: String
        let height: String
    }
    
}


let user = try decoder.decode(User.self, from: beaconmap.json)

let encodedUserData = try? encoder.encode(user)
let userDict = try? JSONSerialization.jsonObject(with: encodedUserData!, options: .mutableContainers) as! NSDictionary


*/
