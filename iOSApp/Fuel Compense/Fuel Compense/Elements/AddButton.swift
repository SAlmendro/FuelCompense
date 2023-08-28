//
//  AddButton.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 20/3/22.
//

import SwiftUI

struct AddButton: View {
    
    @EnvironmentObject var fuelModel: FuelModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var userModel : UserModel
    @State private var showingAddActionSheet = false
    @State private var showingSocialActionSheet = false
    @State private var showFuelModal = false
    @State private var showCompenseModal = false
    @State private var showPicker = false
    @State private var showLogin = false
    @State private var showRegister = false
    @State var title : String
    
    var body: some View {
        HStack{
            Button(action: {}) {
                Image(systemName: "person.circle.fill")
                    .resizable()
            }.actionSheet(isPresented: $showingSocialActionSheet){
                ActionSheet(title: Text(String(localized: "loginOrRegister")), message: Text(String(localized: "loginOrRegMessage")), buttons: [
                    .default(Text(String(localized: "login"))) {
                        showLogin = true
                        showingSocialActionSheet = false
                    },
                    .default(Text(String(localized: "register"))) {
                        showRegister = true
                        showingSocialActionSheet = false
                    }
                ])
            }
            .frame(width: 25, height: 25)
            .padding()
            Spacer()
            Text(title)
            Spacer()
            Button(action: {
                showingAddActionSheet = true
            }) {
                Image(systemName: "plus")
                    .resizable()
            }.actionSheet(isPresented: $showingAddActionSheet){
                ActionSheet(title: Text(String(localized: "add")), message: Text(String(localized: "cv.questionAdd")), buttons: [
                    .default(Text(String(localized: "cv.refueling"))) {
                        if globalsModel.globals.carbonPerLiter == 0 {
                            showPicker = true
                        } else {
                            showFuelModal = true
                        }
                    },
                    .default(Text(String(localized: "cv.compensation"))) {
                       showCompenseModal = true
                    },
                    .cancel()  { }
                ])
            }
            .frame(width: 25, height: 25)
            .padding()
            .sheet(isPresented: $showFuelModal){
                FuelModal(showFuelModal: $showFuelModal, editMode: false)
                    .environmentObject(fuelModel)
                    .environmentObject(globalsModel)
            }
            .sheet(isPresented: $showCompenseModal){
                CompenseModal(showCompenseModal: $showCompenseModal, editMode: false)
                    .environmentObject(carbonModel)
                    .environmentObject(globalsModel)
            }
            .sheet(isPresented: $showPicker) {
                FuelTypeModal(
                    showFuelModal: $showFuelModal,
                    showPicker: $showPicker,
                    selection: (globalsModel.globals.carbonPerLiter == FuelType.gasoline.rawValue) ? FuelType.gasoline : FuelType.gasoil)
                .environmentObject(globalsModel)
            }
            .sheet(isPresented: $showLogin) {
                LoginModal(
                    showLogin: $showLogin)
                .environmentObject(userModel)
            }
        }
        
    }
    
}

