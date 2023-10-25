//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct StatusView: View {
    
    @EnvironmentObject var statusModel : StatusModel
    
    var body: some View {
        VStack{
            RefreshButton(title: String(localized: "sv.title"))
        
            NavigationView{
                List {
                    ForEach(statusModel.subscribedStatuses.indices, id: \.self) { i in
                        NavigationLink(
                            destination: StatusDetail(status: $statusModel.subscribedStatuses[i])
                        ) {
                            StatusRow(status: $statusModel.subscribedStatuses[i])
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear{
            DispatchQueue.global().async {
                statusModel.getSubscribedStatuses()
                statusModel.getStatuses()
            }
        }
    }
    
}


