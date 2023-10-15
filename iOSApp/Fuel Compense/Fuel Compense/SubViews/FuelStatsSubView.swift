//
//  FuelStatsSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 10/10/22.
//

import SwiftUI
import Charts

struct FuelStatsSubSubView: Identifiable {
    let id = UUID()
    let name: String.LocalizationValue
    let number: String
}
let fuelStatsSubSubViews = [ FuelStatsSubSubView(name: "fssv.consume", number: "1"),
               FuelStatsSubSubView(name: "fssv.economic", number: "2") ]

struct FuelStatsSubView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @State var selectedSV = "1"
    
    var body: some View {
        
        VStack{
            Picker("FuelStatsSubSubViews", selection: $selectedSV) {
                ForEach(fuelStatsSubSubViews) { sv in
                    Text(String(localized: sv.name)).tag(sv.number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            if (selectedSV == "1") {
                FuelConsumeStats()
            } else {
                FuelEconomyStats()
            }
            Spacer()
        }
        
    }
    
    
}
