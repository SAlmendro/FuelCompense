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
            HStack {
                Text(String(localized: "fm.odometer") + ": ")
                    .bold()
                Text("\(fuelModel.refills[index].odometer) km")
            }
            .padding()
            HStack {
                Text(String(localized: "fd.trip") + ": ")
                    .bold()
                Text("\(fuelModel.getTrip(i: index)) km")
            }
            .padding()
            HStack {
                Text(String(localized: "fm.liters") + ": ")
                    .bold()
                Text("\(fuelModel.refills[index].liters.round(amountOfDecimals: 2)) L")
            }
            .padding()
            Text("\(fuelModel.refills[index].eurosLiter.round(amountOfDecimals: 3)) €/L")
                .padding()
            HStack {
                Text(String(localized: "fm.total") + ": ")
                    .bold()
                Text("\(fuelModel.refills[index].total.round(amountOfDecimals: 2)) €")
            }
            .padding()
            HStack {
                Text(String(localized: "date") + ": ")
                    .bold()
                Text("\(fuelModel.refills[index].date)")
            }
            .padding()
            if fuelModel.refills[index].fullTank {
                let fullTankData = fuelModel.getFullTankData(i: index)
                HStack {
                    VStack {
                        Text(String(localized: "fd.meanConsume"))
                            .bold()
                        Text("\(fullTankData.meanConsume.round(amountOfDecimals: 2)) L/100km")
                    }
                    .padding()
                    VStack {
                        Text(String(localized: "fd.meanEmissions"))
                            .bold()
                        Text("\(fullTankData.meanEmissions.round(amountOfDecimals: 2)) kgCO2/100km")
                    }
                    .padding()
                }
            } else {
                Text(String(localized: "fd.partial"))
                    .padding()
            }
            HStack {
                Text(String(localized: "fd.totalCarbon") + " ")
                    .bold()
                Text("\(fuelModel.refills[index].totalCarbon.round(amountOfDecimals: 2)) kg")
            }
            .padding()
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
                            Text(String(localized: "delete")),
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
            .padding()

            
        }
    }
}
