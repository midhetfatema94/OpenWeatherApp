//
//  Place+CoreDataClass.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/14/21.
//
//

import Foundation
import CoreData

@objc(Place)
public class Place: NSManagedObject {
    
    func mapObject(from location: Location) {
        self.mainTemp = location.tempDetails.main
        self.minTemp = location.tempDetails.min
        self.maxTemp = location.tempDetails.max
        self.weather = location.weather?.title
        self.weatherIconUrlStr = location.weather?.iconStr
        self.country = location.countryDetails.country
    }
    
    func addObject(from location: Location) {
        self.id = Int32(location.id)
        self.city = location.city
        self.country = location.countryDetails.country
        
        self.currentDate = location.currentDate
        self.mainTemp = location.tempDetails.main
        self.minTemp = location.tempDetails.min
        self.maxTemp = location.tempDetails.max
        self.weather = location.weather?.title
        self.weatherIconUrlStr = location.weather?.iconStr
    }

}
