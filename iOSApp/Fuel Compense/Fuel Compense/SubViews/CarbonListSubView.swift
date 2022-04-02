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
        List {
            ForEach(carbonModel.compensations.indices, id: \.self) { i in
                NavigationLink(destination: CarbonDetail(carbonCompensation: $carbonModel.compensations[i])) {
                    CarbonRow(carbonCompensation: $carbonModel.compensations[i])
                }
            }
        }
    }
}
