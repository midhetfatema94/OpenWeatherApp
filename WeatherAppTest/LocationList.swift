//
//  LocationList.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import Foundation
import Combine

class LocationList: ObservableObject {
    
    @Published var locations = [Location]()
    
    private var cancellable: AnyCancellable?
    
    func searchLocations(string: String) {
        
        let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "ce3a2dcffdmsh4bec54f42db20c3p1228d0jsn69caa6958465"
        ]
        
        let urlString = "https://community-open-weather-map.p.rapidapi.com/find?q=\(string)"
        
        guard let url = URL(string: urlString) else {
            print("URL could not be created")
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in

            guard let data = data else {
                print("No data in response: ", error?.localizedDescription ?? "Unknown error")
                return
            }

            if let result = try? JSONDecoder().decode(Result.self, from: data) {
                DispatchQueue.main.async {[weak self] in
                    let newPage = result.results
                    self?.locations = newPage
                    print("successful response", newPage.count)
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

class Result: Codable {
    
    var statusCode: String
    var results = [Location]()
    
    enum CodingKeys: CodingKey {
        case cod, list
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        statusCode = try container.decode(String.self, forKey: .cod)
        results = try container.decode([Location].self, forKey: .list)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(statusCode, forKey: .cod)
        try container.encode(results, forKey: .list)
    }
}

