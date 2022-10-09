//
//  FuelRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation
import SwiftUI

struct FuelRow: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @Binding var fuelRefill : FuelRefill
    var index : Int
    
    var body: some View {
        HStack {
            VStack {
                Text(fuelRefill.date
                    .formatted(
                        .dateTime
                              .day()
                              .month(.twoDigits)
                              .year()
                    )
                     )
                    .padding()
                Text(String(localized: "fm.odometer") + " \(fuelRefill.odometer) km")
                    .padding()
                Text("\(fuelModel.getTrip(i: index)) km")
                    .padding()
            }
            VStack {
                Text("\(fuelRefill.liters.round(amountOfDecimals: 2)) L")
                    .padding()
                Text("\(fuelRefill.total.round(amountOfDecimals: 2)) €")
                    .padding()
                Text("\(fuelRefill.totalCarbon.round(amountOfDecimals: 2)) kgCO2")
                    .padding()
            }
        }
        
    }
}
