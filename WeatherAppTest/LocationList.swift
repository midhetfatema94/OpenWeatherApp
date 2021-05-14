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

            if let result = try? JSONDecoder().decode(ListResult.self, from: data) {
                DispatchQueue.main.async {[weak self] in
                    self?.locations = result.results
                    print("successful response")
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    func fetchUpdates(cityId: Int, completionHandler: @escaping (Location?) -> Void) {
        
        let apiKey = "a6204763db3fb418f92ae23fbc6f983e"
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("URL could not be created")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in

            guard let data = data else {
                print("No data in response: ", error?.localizedDescription ?? "Unknown error")
                return
            }

            if let result = try? JSONDecoder().decode(Location.self, from: data) {
                DispatchQueue.main.async {
                    completionHandler(result)
                    print("successful response to fetch city updates")
                }
            } else {
                print("Invalid response from server to fetch city updates")
            }
        }.resume()
    }
}

class ListResult: Codable {
    
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

