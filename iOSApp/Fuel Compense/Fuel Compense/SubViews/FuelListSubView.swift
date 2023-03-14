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
            ForEach(fuelModel.refills.indices, id: \.self) { i in
                NavigationLink(
                    destination: FuelDetail(refill: $fuelModel.refills[i], index: i, fullTankData: fuelModel.getFullTankData(i: i))
                        .environmentObject(fuelModel)
                ) {
                    FuelRow(refill: $fuelModel.refills[i], index: i)
                        .environmentObject(fuelModel)
                }
            }
        }
        }
    }
}
