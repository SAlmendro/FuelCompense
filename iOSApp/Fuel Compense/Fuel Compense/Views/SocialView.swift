//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SocialView: View {
    
    @EnvironmentObject var statusModel : StatusModel
    
    var body: some View {
        VStack{
            AddButton(title: String(localized: "sv.title"))
        
            NavigationView{
                List {
                    ForEach(statusModel.statuses.indices, id: \.self) { i in
                        NavigationLink(
                            destination: SocialDetail(status: $statusModel.statuses[i])
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


