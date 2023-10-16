//
//  ContentView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userModel : UserModel
    @State var showRegister = false
    @State var showLogin = false
    @State var notLoggedUser : Bool
    
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
            if (!userModel.notLoggedUser) {
                SocialView()
                    .tabItem{
                        Image(systemName: "person.3")
                        Text(String(localized: "cv.social"))
                    }
            }
            // Usuario
            UserView()
                .tabItem{
                    Image(systemName: "person")
                    Text(String(localized: "cv.user"))
                }
            // Settings
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape.fill")
                    Text(String(localized: "cv.settings"))
                }
        }
        .actionSheet(isPresented: $notLoggedUser){
            ActionSheet(title: Text(String(localized: "loginOrRegister")), message: Text(String(localized: "loginOrRegMessage")), buttons: [
                .default(Text(String(localized: "login"))) {
                    showLogin = true
                },
                .default(Text(String(localized: "register"))) {
                   showRegister = true
                },
                .cancel()
            ])
        }
        .sheet(isPresented: $showLogin){
            LoginModal(showLogin: $showLogin)
        }
        .sheet(isPresented: $showRegister){
            RegisterModal(showRegister: $showRegister)
        }
    }
}
