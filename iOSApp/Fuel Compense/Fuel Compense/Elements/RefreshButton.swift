//
//  RefreshButton.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 14/9/23.
//

import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var statusModel: StatusModel
    @State var title : String
    
    var body: some View {
        HStack{
            Spacer()
            Text(title)
            Spacer()
            Button(action: {
                DispatchQueue.main.async {
                    statusModel.getSubscribedStatuses()
                }
            }) {
                Image(systemName: "goforward")
                    .resizable()
            }
            .frame(width: 25, height: 25)
            .padding()
        }
        
    }
}
