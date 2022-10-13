//
//  FuelEconomyStats.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 13/10/22.
//

import SwiftUI
import Charts

struct FuelEconomyStats: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    
    var body: some View {
        VStack{
            let averageConsume = fuelModel.getAverageEur()
            Chart {
                ForEach(fuelModel.refills.indices, id: \.self) { i in
                    if ((i+1 != fuelModel.refills.count) && fuelModel.refills[i].fullTank) {
                        let fullTankStats = fuelModel.getFullTankData(i: i)
                        LineMark(
                            x: .value("Date", fuelModel.refills[i].date, unit: .day),
                            y: .value("€/100km", fullTankStats.meanEur)
                        )
                    }
                }
                RuleMark(y: .value("Average", averageConsume))
                     .foregroundStyle(.orange)
                     .annotation {
                         Text("\(averageConsume.round(amountOfDecimals: 2)) €/100km")
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
            
            Text(String(localized: "fes.avgConsume") +  averageConsume.round(amountOfDecimals: 2) + " €/100km.")
                .padding()
            Text(String(localized: "fes.totalEur") + "\(fuelModel.getTotalEur().round(amountOfDecimals: 2)) €.")
                .padding()
        }
    }
}
