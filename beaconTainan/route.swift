import UIKit

let jsonString = """
{"Route": {
    "1": {
        "NaviMessage": {
            "1": {
                "Meter": 1,
                "Rssi": -70,
                "Message": "起點：地下道出入口，確認地下道在三點鐘方向，請沿地下道邊牆追跡，向前直行。"
            },
            "2": {
                "Meter": 1,
                "Rssi": -70,
                "Message": "起點：地下道出入口，確認地下道在三點鐘方向，請沿地下道邊牆追跡，向前直行。"
            }
        },
        "ActMessage": {
            "Act1": "null~",
            "Act2": "null~"
        },
        "TrafficLight": "null~",
        "From": 1,
        "To": 2,
        "Angle": 0
    }
}
}
"""
let data = jsonString.data(using: .utf8)!

class BlindNaviBeacon: Codable {
    // MARK: - Properties
    let meter: Int
    let rssi: Int
    let message: String
    let act1: String
    let act2: String
    let trafficLight: String
    let from: Int
    let to: Int
    let angle: Int
    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case route = "Route"
        case naviMessage = "NaviMessage"
        case meter = "Meter"
        case rssi = "Rssi"
        case message = "Message"
        case actMessage = "ActMessage"
        case act1 = "Act1"
        case act2 = "Act2"
        case trafficLight = "TrafficLight"
        case from = "From"
        case to = "To"
        case angle = "Angle"
    }
    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let route = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .route)
        trafficLight = try route.decode(String.self, forKey: .trafficLight)
        from = try route.decode(Int.self, forKey: .from)
        to = try route.decode(Int.self, forKey: .to)
        angle = try route.decode(Int.self, forKey: .angle)
        let naviMessage = try route.nestedContainer(keyedBy: CodingKeys.self, forKey: .naviMessage)
        meter = try naviMessage.decode(Int.self, forKey: .meter)
        rssi = try naviMessage.decode(Int.self, forKey: .rssi)
        message = try naviMessage.decode(String.self, forKey: .message)
        let actMessage = try route.nestedContainer(keyedBy: CodingKeys.self, forKey: .actMessage)
        act1 = try actMessage.decode(String.self, forKey: .act1)
        act2 = try actMessage.decode(String.self, forKey: .act2)
    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var route = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .route)
        try route.encode(trafficLight, forKey: .trafficLight)
        try route.encode(from, forKey: .from)
        try route.encode(to, forKey: .to)
        try route.encode(angle, forKey: .angle)
        var naviMessage = route.nestedContainer(keyedBy: CodingKeys.self, forKey: .naviMessage)
        try naviMessage.encode(meter, forKey: .meter)
        try naviMessage.encode(rssi, forKey: .rssi)
        try naviMessage.encode(message, forKey: .message)
        var actMessage = route.nestedContainer(keyedBy: CodingKeys.self, forKey: .actMessage)
        try actMessage.encode(act1, forKey: .act1)
        try actMessage.encode(act2, forKey: .act2)
    }
}

let myBlindNaviBeacon = try! JSONDecoder().decode(BlindNaviBeacon.self, from: data)
// Initializes a BlindNaviBeacon object from the JSON data at the top.
let dataToSend = try! JSONEncoder().encode(myBlindNaviBeacon)
// Turns your BlindNaviBeacon object into raw JSON data you can send back!
