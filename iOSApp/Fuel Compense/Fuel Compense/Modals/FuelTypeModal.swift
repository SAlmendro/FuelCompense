//
//  FuelTypeModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 12/10/22.
//

import SwiftUI

struct FuelTypeModal: View {
    
    @EnvironmentObject var globalsModel : GlobalsModel
    @Binding var showFuelModal : Bool
    @Binding var showPicker : Bool
    @State var selection : FuelType
    
    var body: some View {
        Form {
            Picker(String(localized: "ftm.selectFuelType"), selection: $selection) {
                ForEach(FuelType.allCases, id: \.self) { value in
                    if value == FuelType.gasoil {
                        Text(String(localized: "gasoil"))
                            .tag(value)
                    } else {
                        Text(String(localized: "gasoline"))
                            .tag(value)
                    }
                }
            }
            HStack {
                Spacer()
                    Button(action: {
                        globalsModel.globals.carbonPerLiter = selection.rawValue
                        showFuelModal = true
                        showPicker = false
                    }) {Text(String(localized: "save"))}
                Spacer()
                Button(action: {
                    showPicker = false
                }) {Text(String(localized: "cancel"))}
                Spacer()
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
