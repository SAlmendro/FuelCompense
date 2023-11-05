//
//  CarbonListSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct CarbonListSubView: View {
    
    @EnvironmentObject var carbonModel : CarbonModel
    @State var showDeleteAllAlert = false
    
    var body: some View {
        NavigationView{
            if carbonModel.compensations.isEmpty {
                VStack {
                    Button(action: {
                        DispatchQueue.global().async {
                            carbonModel.getCompensations()
                        }
                    }) {
                        VStack {
                            Image(systemName: "goforward")
                                .frame(width: 25, height: 25)
                                .padding()
                            Text("clsv.retrieveFromServer")
                        }
                    }
                    .padding()
                }
            } else {
                VStack {
                    if (!carbonModel.unpublishedCompensations.isEmpty || !carbonModel.unpublishedUpdateCompensations.isEmpty) {
                        Button(action: {
                            DispatchQueue.global().async {
                                carbonModel.uploadUnpublished()
                            }
                        }) {
                            Text(String(localized: "clsv.retryUpload"))
                        }
                        .padding()
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                    }
                    List {
                        ForEach(carbonModel.compensations.indices, id: \.self) { i in
                            NavigationLink(
                                destination: CarbonDetail(compensation: $carbonModel.compensations[i], index: i)
                            ) {
                                CarbonRow(compensation: $carbonModel.compensations[i])
                            }
                        }
                    }
                    Button(action: {
                        showDeleteAllAlert = true
                    }) {
                        Text(String(localized: "clsv.deleteAll"))
                    }
                    .padding()
                    .foregroundColor(Color(uiColor: .red))
                    .alert(isPresented: $showDeleteAllAlert) {
                        Alert(
                            title: Text(String(localized: "clsv.deleteAll")),
                            message: Text(String(localized: "clsv.deleteAllMessage")),
                            primaryButton: .cancel() {},
                            secondaryButton: .destructive(
                                Text(String(localized: "clsv.delete")),
                                action: {
                                    carbonModel.deleteAll()
                                }
                            )
                        )
                    }
                }
            }
        }
    }
}
