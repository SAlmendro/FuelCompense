//
//  CarbonDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct CarbonDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var carbonCompensation : CarbonCompensation
    @EnvironmentObject var carbonModel : CarbonModel
    
    var body: some View {
        
        VStack {
            Text(String(localized: "date") + ": \(carbonCompensation.date)")
                .padding()
            Text("kgCO2: \(carbonCompensation.tons*1000)")
                .padding()
            if carbonModel.compensations.last!.id == carbonCompensation.id {
                Button(action: {
                    if carbonModel.delete(uuid: carbonCompensation.id) {
                        self.mode.wrappedValue.dismiss()
                    }
                }, label: {
                    VStack{
                        Image(systemName: "trash")
                        Text(String(localized: "fd.delete"))
                            .font(.footnote)
                    }
                })
            }
        }
        
    }
}
