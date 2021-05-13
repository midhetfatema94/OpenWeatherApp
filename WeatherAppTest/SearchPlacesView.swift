//
//  SearchPlacesView.swift
//  WeatherAppTest
//
//  Created by Midhet Sulemani on 5/13/21.
//

import SwiftUI

struct SearchPlacesView: View {
    
    @ObservedObject var locationList = LocationList()
    
    @State private var searchText = ""
    @State private var selectedId: Int?
    
    var body: some View {
        VStack {
            SearchBarView(locationList: locationList, text: $searchText)
                .padding()
            
            List(locationList.locations) { item in
                Text(item.city)
                    .onTapGesture(perform: {
                                    addPlace(item: item)
                    })
            }
        }
        .navigationTitle("Add New Country")
    }
    
    func addPlace(item: Location) {
        //Add new place code here
        print("add \(item.city) to location")
    }
}

struct SearchPlacesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchPlacesView()
    }
}
