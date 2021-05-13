//
//  WeatherAppTestApp.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import SwiftUI

@main
struct WeatherAppTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
