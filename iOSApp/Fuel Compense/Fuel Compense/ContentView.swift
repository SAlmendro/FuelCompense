//
//  ContentView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    
    var body: some View {
        TabView{
            // Consumos
            FuelView()
                .tabItem{
                    Image(systemName: "car.fill")
                    Text(String(localized: "cv.fuel"))
                }
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
            // CO2
            CarbonView()
                .tabItem{
                    Image(systemName: "leaf.fill")
                    Text("CO2")
                }
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
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
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
