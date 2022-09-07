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
        List {
            ForEach(carbonModel.compensations.indices, id: \.self) { i in
                NavigationLink(
                    destination: CarbonDetail(carbonCompensation: $carbonModel.compensations[i])
                        .environmentObject(carbonModel)
                ) {
                    CarbonRow(carbonCompensation: $carbonModel.compensations[i])
                }
            }
        }
        }
    }
}
