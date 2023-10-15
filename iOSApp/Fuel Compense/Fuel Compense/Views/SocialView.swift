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
            RefreshButton(title: String(localized: "sv.title"))
        
            NavigationView{
                List {
                    ForEach(statusModel.subscribedStatuses.indices, id: \.self) { i in
                        NavigationLink(
                            destination: SocialDetail(status: $statusModel.subscribedStatuses[i])
                        ) {
                            SocialRow(status: $statusModel.subscribedStatuses[i])
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear{
            statusModel.getSubscribedStatuses()
            statusModel.getStatuses()
        }
    }
    
}


