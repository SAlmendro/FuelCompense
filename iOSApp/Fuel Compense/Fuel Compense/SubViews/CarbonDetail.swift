//
//  CarbonDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct CarbonDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var compensation : Compensation
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @State private var showAlert = false
    @State private var showEditSheet = false
    var index = 0
    
    var body: some View {
        
        VStack {
            Text(String(localized: "date") + ": \(compensation.date)")
                .padding()
            Text("kgCO2: \((compensation.tons*1000).round(amountOfDecimals: 0))")
                .padding()
            Text(compensation.comment)
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
                        date: compensation.date,
                        CO2tons: compensation.tons.round(amountOfDecimals: 3),
                        comment: compensation.comment,
                        editMode: true,
                        index: index
                    )
                }
                Spacer()
            }
            .padding()
        }
        
    }
}
