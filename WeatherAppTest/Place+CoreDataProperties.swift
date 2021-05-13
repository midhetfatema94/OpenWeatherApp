//
//  Place+CoreDataProperties.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/14/21.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var id: Int32
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var currentDate: String?
    @NSManaged public var mainTemp: Double
    @NSManaged public var minTemp: Double
    @NSManaged public var maxTemp: Double
    @NSManaged public var weather: String?
    @NSManaged public var weatherIconUrlStr: String?
}

extension Place : Identifiable {

}
