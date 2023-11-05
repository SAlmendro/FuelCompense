//
//  FavsModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 5/11/23.
//

import SwiftUI

struct FavsModal: View {
    
    @State var favs : [String]
    
    var body: some View {
        VStack {
            if (favs.count == 1) {
                Text("1 FAV")
                    .font(.title)
                    .padding()
            } else {
                Text(String(favs.count) + " FAVs")
                    .font(.title)
                    .padding()
            }
            List {
                ForEach(favs.indices, id: \.self) { i in
                    Text(favs[i])
                }
            }
        }
        .padding()
    }
}
