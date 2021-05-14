//
//  Location.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import Foundation

class Location: Codable, Identifiable, Equatable {
    
    var id: Int
    var city: String
    var countryDetails: SystemDetails
    var currentDate: String?
    var tempDetails: TemperatureDetails
    var weather: WeatherDetails?
    
    enum CodingKeys: CodingKey {
        case id, name, sys, main, weather
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        city = try container.decode(String.self, forKey: .name)
        countryDetails = try container.decode(SystemDetails.self, forKey: .sys)
        tempDetails = try container.decode(TemperatureDetails.self, forKey: .main)
        
        let weatherArray = try container.decode([WeatherDetails].self, forKey: .weather)
        if let weatherFirst = weatherArray.first {
            weather = weatherFirst
        }
        
        let date = DateHelper.shared.string(from: Date(), format: "E, d MMM yyyy")
        currentDate = date
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(city, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(countryDetails, forKey: .sys)
        try container.encode(tempDetails, forKey: .main)
        try container.encode(weather, forKey: .weather)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

struct TemperatureDetails: Codable {
    
    var main: Double
    var min: Double
    var max: Double
    
    enum CodingKeys: CodingKey {
        case temp, temp_min, temp_max
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        main = try container.decode(Double.self, forKey: .temp)
        min = try container.decode(Double.self, forKey: .temp_min)
        max = try container.decode(Double.self, forKey: .temp_max)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(main, forKey: .temp)
        try container.encode(min, forKey: .temp_min)
        try container.encode(max, forKey: .temp_max)
    }
}

struct WeatherDetails: Codable {
    
    var title: String
    var iconStr: String
    var description: String?
    
    enum CodingKeys: CodingKey {
        case main, description, icon
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .main)
        description = try container.decode(String.self, forKey: .description)
        
        let icon = try container.decode(String.self, forKey: .icon)
        iconStr = "http://openweathermap.org/img/w/\(icon).png"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .main)
        try container.encode(description, forKey: .description)
        try container.encode(iconStr, forKey: .icon)
    }
}

struct SystemDetails: Codable {
    
    var country: String
    
    enum CodingKeys: CodingKey {
        case country
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        country = try container.decode(String.self, forKey: .country)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(country, forKey: .country)
    }
}
