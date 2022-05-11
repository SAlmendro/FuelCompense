//
//  SocialRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation
import SwiftUI

struct SocialRow: View {

    @Binding var socialUnit : SocialUnit
    
    var body: some View {
        
        VStack {
            
            HStack {
                Text(socialUnit.authUserName)
                Spacer()
            }
            .padding()
            
            Text(socialUnit.text)
                .padding()
            
            HStack {
                if socialUnit.fav {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.gray)
                }
                Spacer()
                Text("\(socialUnit.favs.count) FAVs")
                Spacer()
            }
            .padding()
            
        }
        
    }
}
