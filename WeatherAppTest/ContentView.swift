//
//  ContentView.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Place.city, ascending: true)],
        animation: .default)
    private var places: FetchedResults<Place>
    
    @ObservedObject var locationList = LocationList()

    var body: some View {
        NavigationView {
            List {
                ForEach(places) { item in
                    NavigationLink(
                        destination: WeatherDetailView(),
                        label: {
                            HStack {
                                VStack(spacing: 10) {
                                    Text("\(item.city ?? "Place Details")")
                                    Text("\(item.currentDate ?? "Date Details")")
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("\(String(format: "%.0f", item.mainTemp))F")
                                    Text("\(String(format: "%.0f", item.minTemp))F | \(String(format: "%.0f", item.maxTemp))F")
                                    Text("\(item.weather ?? "Weather detail")")
                                }
                            }
                        })
                }
            }
            .navigationBarItems(trailing:
                                    NavigationLink(
                                        destination: SearchPlacesView(locationList: locationList),
                                        label: {
                                            Image(systemName: "plus")
                                        })
            )
            .navigationTitle("Favourite Places")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { places[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
