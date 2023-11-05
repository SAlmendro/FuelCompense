//
//  SocialRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation
import SwiftUI

struct StatusRow: View {

    @Binding var status : Status
    @EnvironmentObject var userModel : UserModel
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(status.authUserName)
                Spacer()
            }
            
            Text(status.text)
                .padding()
            
            HStack {
                Spacer()
                if (status.favs.contains(userModel.user.userName)) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.gray)
                }
                if (status.favs.count == 1) {
                    Text("1 FAV")
                } else {
                    Text("\(status.favs.count) FAVs")
                }
                Spacer()
            }
            
        }
        
    }
}
