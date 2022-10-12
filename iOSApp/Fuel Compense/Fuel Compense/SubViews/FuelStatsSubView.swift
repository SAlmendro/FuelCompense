//
//  FuelStatsSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 10/10/22.
//

import SwiftUI
import Charts

struct FuelStatsSubView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    
    var body: some View {
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
            AxisMarks(values: .stride(by: .weekOfYear)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.week(.defaultDigits))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 300)
        .padding()
        
        Text(String(localized: "fssv.avgConsume") +  averageConsume.round(amountOfDecimals: 2) + " L/100km.")
            .padding()
        Text(String(localized: "fssv.totalKm") + "\(fuelModel.getTotalKm()) km.")
            .padding()
        Text(String(localized: "fssv.totalLiters") + "\(fuelModel.getTotalConsume()) L.")
            .padding()
        Text(String(localized: "fssv.totalEmissions") + "\(fuelModel.getTotalEmissions())" + String(localized: "fssv.tonsCarbon"))
            .padding()
    }
}
