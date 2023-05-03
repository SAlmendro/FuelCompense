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
    @EnvironmentObject var socialModel : SocialModel
    
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
            Button(action: {
                if socialModel.delete(id: status.id) {
                    self.mode.wrappedValue.dismiss()
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
