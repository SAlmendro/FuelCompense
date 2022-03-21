//
//  CompenseModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CompenseModal: View {
    
    @Binding var showCompenseModal: Bool
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
                    // guardar fecha y kgco2 (este convertirlo a float y a toneladas antes de guardarlo)
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
