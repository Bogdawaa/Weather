import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tzId: String
    let localtimeEpoch: Int
    let localtime: String
    
    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

struct Current: Codable {
    let lastUpdatedEpoch: Int
    let tempC: Double
    let isDay: Int
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
}
