//
//  FuelView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelSubView: Identifiable {
    let id = UUID()
    let name: String.LocalizationValue
    let number: String
}
let fuelSubViews = [ FuelSubView(name: "fv.listSV", number: "1"),
               FuelSubView(name: "fv.statSV", number: "2") ]

struct FuelView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @EnvironmentObject var userModel : UserModel
    @State var selectedSV = "1"
    
    var body: some View {
        
        VStack{
            AddButton(title: String(localized: "fv.title"))
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
                .environmentObject(userModel)
            Picker("FuelSubViews", selection: $selectedSV) {
                ForEach(fuelSubViews) { sv in
                    Text(String(localized: sv.name)).tag(sv.number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            if (selectedSV == "1") {
                FuelListSubView()
                    .environmentObject(fuelModel)
            } else {
                FuelStatsSubView()
                    .environmentObject(fuelModel)
            }
            Spacer()
        }
    }
}
