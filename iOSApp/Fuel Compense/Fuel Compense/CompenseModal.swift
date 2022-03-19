//
//  CompenseModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CompenseModal: View {
    
    @Binding var showCompenseModal: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text("I am CompenseModal, here you will be able to insert new compense entries")
                .padding()
            Spacer()
            HStack{
                Spacer()
                Button(action: {
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
