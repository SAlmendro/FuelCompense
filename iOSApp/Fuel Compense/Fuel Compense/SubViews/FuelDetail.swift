//
//  FuelDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct FuelDetail: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @State private var showAlert = false
    @State private var showEditSheet = false
    @State var index : Int
    
    var body: some View {
        VStack {
            Text(String(localized: "fm.odometer") + ": \(fuelModel.refills[index].odometer) km")
                .padding()
            Text(String(localized: "fd.trip") + ": \(fuelModel.getTrip(i: index)) km")
                .padding()
            Text(String(localized: "fm.liters") + ": \(fuelModel.refills[index].liters.round(amountOfDecimals: 2)) L")
                .padding()
            Text("\(fuelModel.refills[index].eurosLiter.round(amountOfDecimals: 3)) €/L")
                .padding()
            Text(String(localized: "fm.total") + ": \(fuelModel.refills[index].total.round(amountOfDecimals: 2)) €")
                .padding()
            Text(String(localized: "date") + ": \(fuelModel.refills[index].date)")
                .padding()
            if fuelModel.refills[index].fullTank {
                let fullTankData = fuelModel.getFullTankData(i: index)
                HStack {
                    VStack {
                        Text(String(localized: "fd.meanConsume"))
                            .padding()
                        Text("\(fullTankData.meanConsume.round(amountOfDecimals: 2)) L/100km")
                            .padding()
                    }
                    .padding()
                    VStack {
                        Text(String(localized: "fd.meanEmissions"))
                            .padding()
                        Text("\(fullTankData.meanEmissions.round(amountOfDecimals: 2)) kgCO2/100km")
                            .padding()
                    }
                    .padding()
                }
            } else {
                Text(String(localized: "fd.partial"))
                    .padding()
            }
            Text(String(localized: "fd.totalCarbon") + "\(fuelModel.refills[index].totalCarbon.round(amountOfDecimals: 2)) kg")
                .padding()
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    showAlert = true
                }, label: {
                    VStack{
                        Image(systemName: "trash")
                        Text(String(localized: "fd.delete"))
                            .font(.footnote)
                    }
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(String(localized: "fd.delete")),
                        message: Text(String(localized: "fd.questionDelete")),
                        primaryButton: .cancel() {},
                        secondaryButton: .destructive(
                            Text(String(localized: "fd.delete")),
                            action: { fuelModel.delete(index: index) }
                        )
                    )
                }
                Spacer()
                Button(action: {
                    showEditSheet = true
                }, label: {
                    VStack{
                        Image(systemName: "square.and.pencil")
                        Text(String(localized: "fd.edit"))
                            .font(.footnote)
                    }
                })
                .sheet(isPresented: $showEditSheet){
                    FuelModal(showFuelModal: $showEditSheet,
                              odometer: String(fuelModel.refills[index].odometer),
                              liters: String(fuelModel.refills[index].liters).pointToComma(),
                              total: String(fuelModel.refills[index].total).pointToComma(),
                              date: fuelModel.refills[index].date,
                              full: fuelModel.refills[index].fullTank,
                              editMode: true,
                              index: $index)
                }
                Spacer()
            }

            
        }
    }
}
