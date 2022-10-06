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
    @State var CO2kg = "0"
    
    var body: some View {
        VStack{
            Spacer()
            MyForm(fieldName: "kgCO2", fieldNumber: $CO2kg)
            Spacer()
            DatePicker(String(localized: "date"), selection: $date)
                .padding()
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    let compensation = CarbonCompensation(
                        date: date,
                        tons: Float(CO2kg)!*0.001
                    )
                    print(compensation.tons)
                    print("Toneladas convertidas desde kg")
                    carbonModel.compensations.append(compensation)
                    let compensationsSorted = carbonModel.compensations.sorted(by: { (com0: CarbonCompensation, com1: CarbonCompensation) -> Bool in
                        return com0 < com1
                    })
                    carbonModel.compensations = compensationsSorted
                    self.showCompenseModal = false
                }) {Text(String(localized: "add"))}
                Spacer()
                Button(action: {
                    self.showCompenseModal = false
                }) {Text(String(localized: "cancel"))}
                Spacer()
            }
            Spacer()
        }
    }
}
