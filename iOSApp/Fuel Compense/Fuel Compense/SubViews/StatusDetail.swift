//
//  SocialDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import SwiftUI

struct StatusDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var status : Status
    @EnvironmentObject var statusModel : StatusModel
    @EnvironmentObject var userModel : UserModel
    @State private var showFavsModal = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Text(status.authUserName)
                    .padding()
                    .font(.footnote)
            }
            Spacer()
            Text(status.text)
                .padding()
                .background(.gray)
                .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            HStack {
                Spacer()
                if (status.favs.isEmpty) {
                    Text("0 FAVs")
                        .padding()
                } else {
                    Button {
                        showFavsModal = true
                    } label: {
                        if (status.favs.count == 1) {
                            Text("1 FAV")
                        } else {
                            Text("\(status.favs.count) FAVs")
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showFavsModal){
                        FavsModal(favs: status.favs)
                    }
                }
                Button {
                    DispatchQueue.global().async {
                        statusModel.changeFav(status: $status)
                    }
                } label: {
                    if (status.favs.contains(userModel.user.userName)) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.yellow)
                    } else {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.gray)
                    }
                }
                Spacer()
            }
            .padding()
            
            Spacer()

            if (status.authUserName == userModel.user.userName) {
                Button(action: {
                    showDeleteAlert = true
                }, label: {
                    VStack{
                        Image(systemName: "trash")
                        Text(String(localized: "sd.delete"))
                            .font(.footnote)
                    }
                })
                .padding()
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text(String(localized: "sd.delete")),
                        message: Text(String(localized: "sd.questionDelete")),
                        primaryButton: .cancel() {},
                        secondaryButton: .destructive(
                            Text("delete"),
                            action: {
                                statusModel.delete(status: status) { success in
                                    if success {
                                        DispatchQueue.global().async {
                                            statusModel.getSubscribedStatuses()
                                        }
                                    } else {
                                        print("He fallado borrando un estado")
                                    }
                                    DispatchQueue.main.async {
                                        self.mode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        )
                    )
                }
            }
        }
        
    }
}
