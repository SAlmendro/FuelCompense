//
//  FuelConsumeStats.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 13/10/22.
//

import SwiftUI
import Charts

struct FuelConsumeStats: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    
    var body: some View {
        VStack{
            let averageConsume = fuelModel.getAverageConsume()
            Chart {
                ForEach(fuelModel.refills.indices, id: \.self) { i in
                    if ((i+1 != fuelModel.refills.count) && fuelModel.refills[i].fullTank) {
                        let fullTankStats = fuelModel.getFullTankData(i: i)
                        LineMark(
                            x: .value("Date", fuelModel.refills[i].date, unit: .day),
                            y: .value("L/100km", fullTankStats.meanConsume)
                        )
                    }
                }
                RuleMark(y: .value("Average", averageConsume))
                     .foregroundStyle(.orange)
                     .annotation {
                         Text("\(averageConsume.round(amountOfDecimals: 2)) L/100km")
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.defaultDigits))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 300)
            .padding()
            
            Text(String(localized: "fcs.avgConsume") +  averageConsume.round(amountOfDecimals: 2) + " L/100km.")
                .padding()
            Text(String(localized: "fcs.totalKm") + "\(fuelModel.getTotalKm()) km.")
                .padding()
            Text(String(localized: "fcs.totalLiters") + "\(fuelModel.getTotalConsume().round(amountOfDecimals: 2)) L.")
                .padding()
            Text(String(localized: "fcs.totalEmissions") + "\((fuelModel.getTotalEmissions()/1000).round(amountOfDecimals: 3))" + String(localized: "fcs.tonsCarbon"))
                .padding()
        }
    }
}
