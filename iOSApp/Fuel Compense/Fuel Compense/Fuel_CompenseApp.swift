//
//  Fuel_CompenseApp.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

@main
struct Fuel_CompenseApp: App {
    
    let fuelModel = FuelModel()
    let carbonModel = CarbonModel()
    let globalsModel = GlobalsModel()
    let socialModel = SocialModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
                .environmentObject(socialModel)
        }
    }
}
