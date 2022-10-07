//
//  CompenseModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CompenseModal: View {
    
    @Binding var showCompenseModal: Bool
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @State var date = Date()
    @State var CO2kg = ""
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField("kgCO2", text: $CO2kg)
                    DatePicker(String(localized: "date"), selection: $date)
                    HStack{
                        Spacer()
                        Button(action: {
                            if (CO2kg == "") {
                                self.showCompenseModal = false
                            } else {
                                let compensation = CarbonCompensation(
                                    date: date,
                                    tons: Float(CO2kg)!*0.001
                                )
                                print(compensation.tons)
                                print("Toneladas convertidas desde kg")
                                var compensationsTemp = carbonModel.compensations
                                compensationsTemp.append(compensation)
                                let compensationsSorted = compensationsTemp.sorted(by: { (com0: CarbonCompensation, com1: CarbonCompensation) -> Bool in
                                    return com0 < com1
                                })
                                carbonModel.compensations = compensationsSorted
                                self.showCompenseModal = false
                            }
                        }) {Text(String(localized: "add"))}
                        Spacer()
                        Button(action: {
                            self.showCompenseModal = false
                        }) {Text(String(localized: "cancel"))}
                        Spacer()
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
    }
}
