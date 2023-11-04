//
//  FuelListSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct FuelListSubView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @State var showDeleteAllAlert = false
    
    var body: some View {
        NavigationView{
            if (fuelModel.refills.isEmpty) {
                VStack {
                    Button(action: {
                        DispatchQueue.global().async {
                            fuelModel.getRefills()
                        }
                    }) {
                        VStack {
                            Image(systemName: "goforward")
                                .frame(width: 25, height: 25)
                                .padding()
                            Text("flsv.retrieveFromServer")
                        }
                    }
                    .padding()
                }
            } else {
                VStack {
                    List {
                        ForEach(fuelModel.refills.indices, id: \.self) { i in
                            NavigationLink(
                                destination: FuelDetail(index: i) ) {
                                FuelRow(refill: $fuelModel.refills[i], index: i)
                            }
                        }
                    }
                    Button(action: {
                        showDeleteAllAlert = true
                    }) {
                        Text(String(localized: "flsv.deleteAll"))
                    }
                    .padding()
                    .foregroundColor(Color(uiColor: .red))
                    .alert(isPresented: $showDeleteAllAlert) {
                        Alert(
                            title: Text(String(localized: "flsv.deleteAll")),
                            message: Text(String(localized: "flsv.deleteAllMessage")),
                            primaryButton: .cancel() {},
                            secondaryButton: .destructive(
                                Text(String(localized: "flsv.delete")),
                                action: {
                                    fuelModel.deleteAll()
                                }
                            )
                        )
                    }
                }
            }
        }
    }
}
