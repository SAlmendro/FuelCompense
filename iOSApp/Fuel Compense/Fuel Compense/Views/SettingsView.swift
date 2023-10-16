//
//  SettingsView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel

    @State var showPicker = false
    @State var showAlert = false
    @State var showFuelModal = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(String(localized: "sv.fuel"))) {
                    HStack {
                        Text(String(localized: "sv.fuelSelected"))
                        Spacer()
                        if globalsModel.globals.carbonPerLiter == FuelType.gasoil.rawValue {
                            Text(String(localized: "gasoil"))
                        } else if globalsModel.globals.carbonPerLiter == FuelType.gasoline.rawValue {
                            Text(String(localized: "gasoline"))
                        }
                    }
                    Button(action: {
                        showAlert = true
                    }) { Text("sv.changeFuel") }
                }
                Section(header: Text(String(localized: "sv.sync"))) {
                    Text("Refills no enviados         " + String(fuelModel.unpublishedRefills.count))
                }
            }
            .navigationTitle("cv.settings")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(String(localized: "sv.changeFuel")),
                    message: Text(String(localized: "sv.questionChangeFuel")),
                    primaryButton: .cancel() {},
                    secondaryButton: .destructive(
                        Text(String(localized: "sv.change")),
                        action: {
                            showPicker = true
                        }
                    )
                )
            }
            .sheet(isPresented: $showPicker) {
                FuelTypeModal(
                    showFuelModal: $showFuelModal,
                    showPicker: $showPicker,
                    selection: (globalsModel.globals.carbonPerLiter == FuelType.gasoline.rawValue) ? FuelType.gasoline : FuelType.gasoil
                )
            }
        }
    }
}
