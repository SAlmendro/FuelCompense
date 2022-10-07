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
    @State var odometer = ""
    @State var liters = ""
    @State var eurosLiter = 0.0
    @State var total = ""
    @State var date = Date()
    @State var full = true
    
    var body: some View {
        VStack{
            Spacer()
            VStack {
                Form {
                    Section {
                        TextField(String(localized: "fm.odometer"), text: $odometer)
                        TextField(String(localized: "fm.liters"), text: $liters)
                        HStack {
                            Text("€/L")
                            Spacer()
                            Text(String((Float(total) ?? 0)/(Float(liters) ?? 1)) + " €/L" )
                        }
                        TextField(String(localized: "fm.total"), text: $total)
                        DatePicker(String(localized: "date"), selection: $date)
                        Toggle(isOn: $full) { Text(String(localized: "fm.full")) }
                        HStack{
                            Spacer()
                            Button(action: {
                                if ((odometer == "") || (liters == "") || (total == "")) {
                                    self.showFuelModal = false
                                } else {
                                    let refill = FuelRefill(
                                        odometer: Int(odometer)!,
                                        liters: Float(liters)!,
                                        eurosLiter: (Float(total) ?? 0)/(Float(liters) ?? 1),
                                        total: Float(total)!,
                                        date: date,
                                        fullTank: full,
                                        totalCarbon: (Float(liters)!*2.5) //poner el del anterior
                                    )
                                    var refillsTemp = fuelModel.refills
                                    refillsTemp.append(refill)
                                    let refillsSorted = refillsTemp.sorted(by: { (ref0: FuelRefill, ref1: FuelRefill) -> Bool in
                                        return ref0 > ref1
                                    })
                                    fuelModel.refills = refillsSorted
                                    // guardar datos convirtiendo a float primero todos los string
                                    self.showFuelModal = false
                                }
                            }) {Text(String(localized: "add"))}
                            Spacer()
                            Button(action: {
                                self.showFuelModal = false
                            }) {Text(String(localized: "cancel"))}
                            Spacer()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}
