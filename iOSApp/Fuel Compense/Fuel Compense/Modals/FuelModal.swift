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
    @EnvironmentObject var globalsModel : GlobalsModel
   // @State var lastOdometer = (globalsModel.globals.lastRefuel?.odometer ?? 0)
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
                .padding()
            // Text(String(localized: "fd.trip") + String(globalsModel.globals.lastRefuel?.odometer))
            MyForm(fieldName: String(localized: "fm.liters"), fieldNumber: $liters)
                .padding()
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
                    let refill = FuelRefill(
                        odometer: Int(odometer)!,
                        trip: 1,
                        liters: Float(liters)!,
                        eurosLiter: Float(eurosLiter),
                        total: Float(total)!,
                        date: date,
                        fullTank: full,
                        meanConsume: 1,
                        meanEmissions: 1,
                        totalCarbon: (Float(liters)!*2.5),
                        previousRefill: UUID() //poner el del anterior
                    )
                    fuelModel.refills.append(refill)
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
