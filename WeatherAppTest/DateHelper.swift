//
//  DateHelper.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    let dateFormatter = DateFormatter()
    
    func date(from dateString: String, format: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: dateString)
    }
    
    func string(from date: Date, format: String) -> String {
//        dateFormatter.dateFormat = "DD MMM YYYY"
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: date)
    }
}
