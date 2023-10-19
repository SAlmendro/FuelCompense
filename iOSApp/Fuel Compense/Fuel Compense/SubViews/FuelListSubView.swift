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
            if (fuelModel.refills.isEmpty) {
                VStack {
                    Button(action: {
                        DispatchQueue.main.async {
                            fuelModel.getRefills()
                        }
                    }) {
                        VStack {
                            Image(systemName: "goforward")
                                .frame(width: 25, height: 25)
                                .padding()
                            Text("Recuperar estados del servidor")
                        }
                    }
                    .padding()
                }
            } else {
                List {
                    ForEach(fuelModel.refills.indices, id: \.self) { i in
                        NavigationLink(
                            destination: FuelDetail(index: i) ) {
                            FuelRow(refill: $fuelModel.refills[i], index: i)
                        }
                    }
                }
            }
        }
    }
}
