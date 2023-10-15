//
//  Fuel_CompenseApp.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/3/22.
//

import SwiftUI

@main
struct Fuel_CompenseApp: App {
    
    let userModel : UserModel
    let fuelModel : FuelModel
    let carbonModel = CarbonModel()
    let globalsModel = GlobalsModel()
    let statusModel : StatusModel
    
    init() {
        self.userModel = UserModel(globalsModel: globalsModel)
        self.statusModel = StatusModel(userModel: userModel, globalsModel: globalsModel)
        self.fuelModel = FuelModel(globalsModel: globalsModel, userModel: userModel)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userModel)
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
                .environmentObject(statusModel)
        }
    }
}
