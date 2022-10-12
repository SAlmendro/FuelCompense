//
//  CarbonStatsSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 10/10/22.
//

import SwiftUI
import Charts

struct CarbonStatsSubView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    
    var body: some View {
        let averageEmissions = fuelModel.getAverageEmissions()
        let totalEmissions = fuelModel.getTotalEmissions()
        let totalCompensed = carbonModel.getTotalCompensedInKg()
        let netCarbon = totalEmissions - totalCompensed
        Chart {
            ForEach(fuelModel.refills.indices, id: \.self) { i in
                if ((i+1 != fuelModel.refills.count) && fuelModel.refills[i].fullTank) {
                    let fullTankStats = fuelModel.getFullTankData(i: i)
                    LineMark(
                        x: .value("Date", fuelModel.refills[i].date, unit: .day),
                        y: .value("kgCO2/100km", fullTankStats.meanEmissions)
                    )
                }
            }
            RuleMark(y: .value("Average", averageEmissions))
                 .foregroundStyle(.orange)
                 .annotation {
                     Text("\(Int(averageEmissions)) kgC02/100km")
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
        
        Text(String(localized: "cssv.avgEmissions") +  averageEmissions.round(amountOfDecimals: 2) + " kgCO2/100km")
            .padding()
        if netCarbon > 0 {
            Text(String(localized: "cssv.netEmissions") + netCarbon.round(amountOfDecimals: 2) + " kg " + String(localized: "cssv.of") + " CO2")
                .padding()
                .bold()
                .foregroundColor(Color(uiColor: .red))
        } else {
            Text(String(localized: "cssv.netEmissions") + netCarbon.round(amountOfDecimals: 2) + " kg " + String(localized: "cssv.of") + " CO2")
                .padding()
                .bold()
                .foregroundColor(Color(uiColor: .green))
            Text(String(localized: "cssv.congrats"))
                .padding()
                .bold()
                .foregroundColor(Color(uiColor: .green))
                .cornerRadius(2)
        }
        if (netCarbon > 0) {
            Button(String(localized: "cssv.compense") + netCarbon.round(amountOfDecimals: 2) + " kg" + String(localized: "cssv.of") + "CO2") {
                if let yourURL = URL(string: "https://www.ceroco2.org/compensacion/index.php?toneladas=" + (netCarbon/1000).round(amountOfDecimals: 3)) {
                        UIApplication.shared.open(yourURL)
                    }
            }
            .buttonStyle(.bordered)
            .tint(.green)
            .padding()
        }
    }
}
