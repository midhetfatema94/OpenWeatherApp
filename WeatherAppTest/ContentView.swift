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
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.city ?? "Place Details"), \(item.country ?? "Country Details")")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("\(item.currentDate ?? "Date Details")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 8) {
                            Text("\(String(format: "%.0f", item.mainTemp))F")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("\(String(format: "%.0f", item.minTemp))F | \(String(format: "%.0f", item.maxTemp))F")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("\(item.weather ?? "Weather detail")")
                                .font(.footnote)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    deletePlaces(at: indexSet)
                })
            }
            .navigationBarItems(trailing:
                                    NavigationLink(
                                        destination: SearchPlacesView(locationList: locationList),
                                        label: {
                                            Image(systemName: "plus")
                                        })
            )
            .navigationTitle("Favourite Places")
            .onAppear(perform: fetchServerUpdates)
        }
    }
    
    func fetchServerUpdates() {
        for place in places {
            locationList.fetchUpdates(cityId: Int(place.id)) {(cityResult) in
                DispatchQueue.main.async {
                    if let city = cityResult {
                        if let cachedPlace = places.filter({ $0.id == city.id }).first {
                            cachedPlace.mainTemp = city.tempDetails.main
                            cachedPlace.minTemp = city.tempDetails.min
                            cachedPlace.maxTemp = city.tempDetails.max
                            cachedPlace.weather = city.weather?.title
                            cachedPlace.weatherIconUrlStr = city.weather?.iconStr
                            cachedPlace.country = city.countryDetails.country
                            
                            do {
                                try self.viewContext.save()
                            } catch {
                                print("Unable to add new place")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deletePlaces(at offsets: IndexSet) {
        for offset in offsets {
            let place = places[offset]
            viewContext.delete(place)
            
            do {
                try viewContext.save()
            } catch {
                print("Unable to delete place")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
