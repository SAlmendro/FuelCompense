//
//  SocialDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import SwiftUI

struct SocialDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var status : Status
    @EnvironmentObject var statusModel : StatusModel
    @EnvironmentObject var userModel : UserModel
    
    var body: some View {
        
        VStack {
            Text(status.authUserName)
                .padding()
            Text(status.text)
                .padding()
            HStack {
                Button {
                    // change FAV state, añadiendo o eliminando mi username del array de favs
                } label: {
                    Text("\(status.favs.count) FAVs")
                }

            }
            if (status.authUserName == userModel.user.userName) {
                Button(action: {
                    statusModel.delete(status: status) { success in
                        DispatchQueue.main.async {
                            if success {
                                statusModel.getStatuses()
                                statusModel.getSubscribedStatuses()
                                self.mode.wrappedValue.dismiss()
                            } else {
                                // lanzar alerta de fallo
                                print("He fallado borrando un estado")
                            }
                        }
                    }
                    
                }, label: {
                    VStack{
                        Image(systemName: "trash")
                        Text(String(localized: "fd.delete"))
                            .font(.footnote)
                    }
                })
            }
        }
        
    }
}
