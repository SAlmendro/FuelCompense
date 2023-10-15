//
//  CarbonView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CarbonSubView: Identifiable {
    let id = UUID()
    let name: String.LocalizationValue
    let number: String
}
let carbonSubViews = [ CarbonSubView(name: "cav.statSV", number: "1"),
               CarbonSubView(name: "cav.listSV", number: "2") ]

struct CarbonView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @EnvironmentObject var userModel : UserModel
    @State var selectedSV = "1"
    
    var body: some View {
        
        VStack{
            AddButton(title: String(localized: "cav.title"))
            Picker("CarbonSubViews", selection: $selectedSV) {
                ForEach(carbonSubViews) { sv in
                    Text(String(localized: sv.name)).tag(sv.number)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            if (selectedSV == "1") {
                CarbonStatsSubView()
            } else {
                CarbonListSubView()
            }
            
            Spacer()
        }
        
    }
}
