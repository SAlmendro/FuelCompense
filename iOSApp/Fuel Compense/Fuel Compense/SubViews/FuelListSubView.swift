//
//  FuelListSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct FuelListSubView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    
    var body: some View {
        NavigationView{
        List {
            ForEach(fuelModel.refills.indices.reversed(), id: \.self) { i in
                NavigationLink(
                    destination: FuelDetail(fuelRefill: $fuelModel.refills[i])
                        .environmentObject(fuelModel)
                ) {
                    FuelRow(fuelRefill: $fuelModel.refills[i])
                }
            }
        }
        }
    }
}
