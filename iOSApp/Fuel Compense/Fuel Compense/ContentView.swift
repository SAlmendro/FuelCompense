//
//  ContentView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @EnvironmentObject var statusModel : StatusModel
    @State var showRegister = false
    @State var showLogin = false
    
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
                .environmentObject(statusModel)
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
            // Usuario
            UserView()
                .tabItem{
                    Image(systemName: "person")
                    Text(String(localized: "cv.user"))
                }
                .environmentObject(userModel)
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
        .actionSheet(isPresented: $userModel.notLoggedUser){
            ActionSheet(title: Text(String(localized: "loginOrRegister")), message: Text(String(localized: "loginOrRegMessage")), buttons: [
                .default(Text(String(localized: "login"))) {
                    showLogin = true
                },
                .default(Text(String(localized: "register"))) {
                   showRegister = true
                }
            ])
        }
        .sheet(isPresented: $showLogin){
            LoginModal(showLogin: $showLogin)
                .environmentObject(userModel)
        }
        .sheet(isPresented: $showRegister){
            RegisterModal(showRegister: $showRegister)
                .environmentObject(userModel)
        }
    }
}
