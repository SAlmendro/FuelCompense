//
//  FuelModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelModal: View {
    
    @Binding var showFuelModal: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text("I am FuelModal, here you will be able to insert new fuel entries")
                .padding()
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    self.showFuelModal = false
                }) {Text(String(localized: "add"))}
                Spacer()
                Button(action: {
                    self.showFuelModal = false
                }) {Text(String(localized: "cancel"))}
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}
