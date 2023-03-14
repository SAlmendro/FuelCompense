//
//  SocialRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation
import SwiftUI

struct SocialRow: View {

    @Binding var status : Status
    
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
                /*  Cuando sepa dónde guardo mi nombre de usuario, debo buscar mi nombre
                        de usuario en el array de favs para comprobar si yo he dado fav
                if socialUnit.fav {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.gray)
                }
                 */
                Spacer()
                Text("\(status.favs.count) FAVs")
                Spacer()
            }
            .padding()
            
        }
        
    }
}
