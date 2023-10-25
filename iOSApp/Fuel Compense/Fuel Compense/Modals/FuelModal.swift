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
    @State var odometer = ""
    @State var liters = ""
    @State var eurosLiter = 0.0
    @State var total = ""
    @State var date = Date()
    @State var full = true
    var editMode : Bool
    @Binding var index : Int
    
    var body: some View {
        VStack{
            Spacer()
            VStack {
                Form {
                    Section {
                        TextField(String(localized: "fm.odometer"), text: $odometer)
                            .keyboardType(.numberPad)
                        TextField(String(localized: "fm.liters"), text: $liters)
                            .keyboardType(.decimalPad)
                        HStack {
                            Text("€/L")
                            Spacer()
                            Text(((Float(total.commaToPoint()) ?? 0)/(Float(liters.commaToPoint()) ?? 1)).round(amountOfDecimals: 3) + " €/L" )
                        }
                        TextField(String(localized: "fm.total"), text: $total)
                            .keyboardType(.decimalPad)
                        DatePicker(String(localized: "date"), selection: $date)
                        Toggle(isOn: $full) { Text(String(localized: "fm.full")) }
                        HStack{
                            Spacer()
                            if (editMode) {
                                Button(action: {
                                    if ((odometer == "") || (liters == "") || (total == "")) {
                                        self.showFuelModal = false
                                    } else {
                                        let id = fuelModel.refills[index].id
                                        fuelModel.refills[index].odometer = Int(odometer)!
                                        fuelModel.refills[index].liters = Float(liters.commaToPoint())!
                                        fuelModel.refills[index].eurosLiter = (Float(total.commaToPoint())!)/(Float(liters.commaToPoint())!)
                                        fuelModel.refills[index].total = Float(total.commaToPoint())!
                                        fuelModel.refills[index].date = date
                                        fuelModel.refills[index].fullTank = full
                                        fuelModel.refills[index].totalCarbon = (Float(liters.commaToPoint())!*globalsModel.globals.carbonPerLiter)
                                        DispatchQueue.global().async {
                                            fuelModel.updateRefill(refill: fuelModel.refills[index])
                                        }
                                        let refillsTemp = fuelModel.refills
                                        let refillsSorted = refillsTemp.sorted(by: { (ref0: Refill, ref1: Refill) -> Bool in
                                            return ref0 > ref1
                                        })
                                        fuelModel.refills = refillsSorted
                                        
                                        index = fuelModel.refills.firstIndex(where: {$0.id == id}).unsafelyUnwrapped
                                        
                                        self.showFuelModal = false
                                    }
                                }) {Text(String(localized: "fm.save"))}
                            } else {
                                Button(action: {
                                    if ((odometer == "") || (liters == "") || (total == "")) {
                                        self.showFuelModal = false
                                    } else {
                                        let refill = Refill(
                                            date: date,
                                            eurosLiter: (Float(total.commaToPoint()) ?? 0)/(Float(liters.commaToPoint()) ?? 1),
                                            fullTank: full,
                                            liters: Float(liters.commaToPoint())!,
                                            odometer: Int(odometer)!,
                                            total: Float(total.commaToPoint())!,
                                            totalCarbon: (Float(liters.commaToPoint())!*globalsModel.globals.carbonPerLiter)
                                        )
                                        DispatchQueue.global().async {
                                            fuelModel.publishRefill(refill: refill)
                                        }
                                        self.showFuelModal = false
                                    }
                                }) {Text(String(localized: "add"))}
                            }
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
