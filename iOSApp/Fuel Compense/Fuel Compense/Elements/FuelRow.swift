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
    @Binding var refill : Refill
    var index : Int
    
    var body: some View {
        HStack {
            VStack {
                Text(refill.date
                    .formatted(
                        .dateTime
                              .day()
                              .month(.twoDigits)
                              .year()
                    )
                     )
                Text("\(refill.odometer) km")
                    .bold()
                Text("\(fuelModel.getTrip(i: index)) km")
            }
            .padding()
            VStack {
                Text("\(refill.liters.round(amountOfDecimals: 2)) L")
                Text("\(refill.total.round(amountOfDecimals: 2)) €")
                Text("\(refill.totalCarbon.round(amountOfDecimals: 2)) kgCO2")
            }
            .padding()
        }
        
    }
}
