//
//  CarbonListSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct CarbonListSubView: View {
    
    @EnvironmentObject var carbonModel : CarbonModel
    
    var body: some View {
        NavigationView{
            if carbonModel.compensations.isEmpty {
                VStack {
                    Button(action: {
                        DispatchQueue.global().async {
                            carbonModel.getCompensations()
                        }
                    }) {
                        VStack {
                            Image(systemName: "goforward")
                                .frame(width: 25, height: 25)
                                .padding()
                            Text("clsv.retrieveFromServer")
                        }
                    }
                    .padding()
                }
            } else {
                List {
                    ForEach(carbonModel.compensations.indices, id: \.self) { i in
                        NavigationLink(
                            destination: CarbonDetail(compensation: $carbonModel.compensations[i], index: i)
                        ) {
                            CarbonRow(compensation: $carbonModel.compensations[i])
                        }
                    }
                }
            }
        }
    }
}
