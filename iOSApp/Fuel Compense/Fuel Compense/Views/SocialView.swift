//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SocialView: View {
    
    @EnvironmentObject var socialModel : SocialModel
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    
    var body: some View {
        VStack{
            AddButton(title: String(localized: "sv.title"))
                .environmentObject(fuelModel)
                .environmentObject(carbonModel)
                .environmentObject(globalsModel)
        
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
            Spacer()
        }
        
    }
}


