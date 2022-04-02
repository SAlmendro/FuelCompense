//
//  FuelModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelModal: View {
    
    @Binding var showFuelModal: Bool
    @EnvironmentObject var fuelModel : FuelModel
    @State var odometer = "0"
    @State var liters = "1"
    @State var eurosLiter = 0.0
    @State var total = "0"
    @State var date = Date()
    @State var full = true
    
    var body: some View {
        VStack{
            Spacer()
            MyForm(fieldName: String(localized: "fm.odometer"), fieldNumber: $odometer)
            MyForm(fieldName: String(localized: "fm.liters"), fieldNumber: $liters)
            HStack {
                Text("€/L")
                    .padding()
                Spacer()
                Text(String((Float(total) ?? 0)/(Float(liters) ?? 1)) + "€/L" )
                    .padding()
            }
            MyForm(fieldName: String(localized: "fm.total"), fieldNumber: $total)
            DatePicker(String(localized: "date"), selection: $date)
                .padding()
            Spacer()
            Toggle(isOn: $full) {
                Text(String(localized: "fm.full"))
            }
            .padding()
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    fuelModel.refills.append(FuelRefill(odometer: Int(odometer)!, liters: Float(liters)!, eurosLiter: Float(eurosLiter), total: Float(total)!, date: date, fullTank: full, totalCarbon: (Float(liters)!*2.5)))
                    // guardar datos convirtiendo a float primero todos los string
                    self.showFuelModal = false
                }) {Text(String(localized: "add"))}
                Spacer()
                Button(action: {
                    self.showFuelModal = false
                }) {Text(String(localized: "cancel"))}
            }
        }
        .padding()
    }
}
