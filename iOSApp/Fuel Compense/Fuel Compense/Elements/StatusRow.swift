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
            .padding()
            
            Text(status.text)
                .padding()
            
            HStack {
                if (status.favs.contains(userModel.user.userName)) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.gray)
                }
                Spacer()
                Text("\(status.favs.count) FAVs")
                Spacer()
            }
            .padding()
            
        }
        
    }
}
