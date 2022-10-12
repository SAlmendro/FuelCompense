//
//  CompenseModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CompenseModal: View {
    
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @Binding var showCompenseModal: Bool
    @State var date = Date()
    @State var CO2tons = ""
    var editMode : Bool
    var index = 0
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField(String(localized: "cm.tons"), text: $CO2tons)
                        .keyboardType(.decimalPad)
                    DatePicker(String(localized: "date"), selection: $date)
                    HStack{
                        Spacer()
                        if (editMode) {
                            Button(action: {
                                if (CO2tons == "") {
                                    self.showCompenseModal = false
                                } else {
                                    carbonModel.compensations[index].tons = Float(CO2tons.commaToPoint())!
                                    carbonModel.compensations[index].date = date
                                    self.showCompenseModal = false
                                }
                            }) {Text(String(localized: "fm.save"))}
                        } else {
                            Button(action: {
                                if (CO2tons == "") {
                                    self.showCompenseModal = false
                                } else {
                                    let compensation = CarbonCompensation(
                                        date: date,
                                        tons: Float(CO2tons.commaToPoint())!
                                    )
                                    var compensationsTemp = carbonModel.compensations
                                    compensationsTemp.append(compensation)
                                    let compensationsSorted = compensationsTemp.sorted(by: { (com0: CarbonCompensation, com1: CarbonCompensation) -> Bool in
                                        return com0 < com1
                                    })
                                    carbonModel.compensations = compensationsSorted
                                    self.showCompenseModal = false
                                }
                            }) {Text(String(localized: "add"))}
                        }
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
