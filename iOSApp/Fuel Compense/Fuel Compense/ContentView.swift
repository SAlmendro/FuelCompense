//
//  ContentView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView{
            // Consumos
            FuelView()
                .tabItem{
                    Image(systemName: "car.fill")
                    Text(String(localized: "cv.fuel"))
                }
            // CO2
            CarbonView()
                .tabItem{
                    Image(systemName: "leaf.fill")
                    Text("CO2")
                }
            // Social (inicio)
            SocialView()
                .tabItem{
                    Image(systemName: "person.3")
                    Text(String(localized: "cv.social"))
                }
            // Settings
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text(String(localized: "cv.settings"))
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
