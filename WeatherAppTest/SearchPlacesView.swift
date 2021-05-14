//
//  SearchPlacesView.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import SwiftUI

struct SearchPlacesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var locationList = LocationList()
    
    @State private var searchText = ""
    @State private var selectedId: Int?
    
    var body: some View {
        VStack {
            SearchBarView(locationList: locationList, text: $searchText)
                .padding()
            
            List(locationList.locations) { item in
                Text("\(item.city), \(item.countryDetails.country)")
                    .onTapGesture(perform: {
                                    addPlace(item: item)
                    })
            }
        }
        .navigationTitle("Add New Country")
    }
    
    func addPlace(item: Location) {
        //Add new place code here
        let newPlace = Place(context: viewContext)
        newPlace.addObject(from: item)
        
        do {
            try self.viewContext.save()
            self.presentationMode.wrappedValue.dismiss()
        } catch {
            print("Unable to save new city")
        }
    }
}

struct SearchPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPlacesView()
    }
}
