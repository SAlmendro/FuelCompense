//
//  FuelDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct FuelDetail: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var fuelRefill : FuelRefill
    @EnvironmentObject var fuelModel : FuelModel
    
    var body: some View {
        VStack {
            Text(String(localized: "fm.odometer") + ": \(fuelRefill.odometer) km")
                .padding()
            Text(String(localized: "fd.trip") + ": \(fuelRefill.trip) km")
                .padding()
            Text(String(localized: "fm.liters") + ": \(fuelRefill.liters) L")
                .padding()
            Text(String(localized: "€/L:") + "\(fuelRefill.eurosLiter) €/L")
                .padding()
            Text(String(localized: "fm.total") + ": \(fuelRefill.total) €")
                .padding()
            Text(String(localized: "date") + ": \(fuelRefill.date)")
                .padding()
            if fuelRefill.fullTank {
                HStack {
                    VStack {
                        Text(String(localized: "fd.meanConsume"))
                            .padding()
                        Text("\(fuelRefill.meanConsume) L/100km")
                            .padding()
                    }
                    .padding()
                    VStack {
                        Text(String(localized: "fd.meanEmissions"))
                            .padding()
                        Text("\(fuelRefill.meanConsume) kgCO2/100km")
                            .padding()
                    }
                    .padding()
                }
            } else {
                Text(String(localized: "fd.partial"))
                    .padding()
            }
            Text(String(localized: "fd.totalCarbon") + "\(fuelRefill.totalCarbon) kg")
                .padding()
            Spacer()
            Button(action: {
                if fuelModel.delete(uuid: fuelRefill.id) {
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
