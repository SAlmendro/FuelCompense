//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SocialView: View {
    
    @EnvironmentObject var statusModel : StatusModel
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
                    ForEach(statusModel.statuses.indices, id: \.self) { i in
                        NavigationLink(
                            destination: SocialDetail(status: $statusModel.statuses[i])
                                .environmentObject(statusModel)
                        ) {
                            SocialRow(status: $statusModel.statuses[i])
                        }
                    }
                }
            }
            Spacer()
        }
        
    }
}


