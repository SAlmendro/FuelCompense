//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SocialView: View {
    
    @EnvironmentObject var socialModel : SocialModel
    
    var body: some View {
        
        NavigationView{
            List {
                ForEach(socialModel.socialUnits.indices, id: \.self) { i in
                    NavigationLink(
                        destination: SocialDetail(socialUnit: $socialModel.socialUnits[i])
                            .environmentObject(socialModel)
                    ) {
                        SocialRow(socialUnit: $socialModel.socialUnits[i])
                    }
                }
            }
        }
        
    }
}


