//
//  FuelRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation
import SwiftUI

struct FuelRow: View {

    @Binding var fuelRefill : FuelRefill
    
    let meanConsume = 1;
    let meanCarbon = 1;
    let tripKm = 1;
    let kmFromLastFull = 1;
    
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
                HStack {
                    VStack {
                        Text("\(meanConsume) L/100km")
                            .padding()
                        Text("\(meanCarbon) kgCO2/100km")
                            .padding()
                    }
                    Text(String(localized: "fr.lastKM") + "\(kmFromLastFull) km")
                        .padding()
                }
            }
            VStack {
                Text(String(localized: "fm.odometer") + " \(fuelRefill.odometer) km")
                    .padding()
                Text("\(tripKm) km")
                    .padding()
            }
            VStack {
                Text("\(fuelRefill.liters) L")
                    .padding()
                Text("\(fuelRefill.total) €")
                    .padding()
                Text("\(fuelRefill.totalCarbon) kgCO2")
                    .padding()
            }
        }
        
    }
}
