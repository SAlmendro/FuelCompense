//
//  ContentView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingActionSheet = false
    @State private var showFuelModal = false
    @State private var showCompenseModal = false
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: {
                showingActionSheet = true
            }) {
                Image(systemName: "plus")
                    .resizable()
            }.actionSheet(isPresented: $showingActionSheet){
                ActionSheet(title: Text(String(localized: "add")), message: Text(String(localized: "cv.questionAdd")), buttons: [
                    .default(Text(String(localized: "cv.refueling"))) { showFuelModal = true },
                    .default(Text(String(localized: "cv.compensation"))) { showCompenseModal = true },
                    .cancel()  { }
                ])
            }
            .frame(width: 25, height: 25)
            .padding()
            .sheet(isPresented: $showFuelModal){
                FuelModal(showFuelModal: $showFuelModal)
            }
            .sheet(isPresented: $showCompenseModal){
                CompenseModal(showCompenseModal: $showCompenseModal)
            }
        }
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
