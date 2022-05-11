//
//  SocialDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import SwiftUI

struct SocialDetail: View {
    
    @Environment(\.presentationMode) var mode : Binding<PresentationMode>
    @Binding var socialUnit : SocialUnit
    @EnvironmentObject var socialModel : SocialModel
    
    var body: some View {
        
        VStack {
            Text(socialUnit.authUserName)
                .padding()
            Text(socialUnit.text)
                .padding()
            HStack {
                Button {
                    // change FAV state
                } label: {
                    Text("\(socialUnit.favs.count) FAVs")
                }

            }
            Button(action: {
                if socialModel.delete(uuid: socialUnit.id) {
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
