//
//  CarbonDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct CarbonDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var carbonCompensation : CarbonCompensation
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @State private var showAlert = false
    @State private var showEditSheet = false
    var index = 0
    
    var body: some View {
        
        VStack {
            Text(String(localized: "date") + ": \(carbonCompensation.date)")
                .padding()
            Text("kgCO2: \((carbonCompensation.tons*1000).round(amountOfDecimals: 0))")
                .padding()
            Text(carbonCompensation.comment)
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
                        message: Text(String(localized: "cd.questionDelete")),
                        primaryButton: .cancel() {},
                        secondaryButton: .destructive(
                            Text("fd.delete"),
                            action: { carbonModel.delete(index: index) }
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
                    CompenseModal(
                        showCompenseModal: $showEditSheet,
                        date: carbonCompensation.date,
                        CO2tons: carbonCompensation.tons.round(amountOfDecimals: 3),
                        comment: carbonCompensation.comment,
                        editMode: true,
                        index: index
                    )
                    .environmentObject(carbonModel)
                    .environmentObject(globalsModel)
                }
                Spacer()
            }
            .padding()
        }
        
    }
}
