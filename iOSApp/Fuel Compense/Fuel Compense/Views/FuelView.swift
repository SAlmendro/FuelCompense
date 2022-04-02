//
//  FuelView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelView: View {
    var body: some View {
        
        let fuelModel = FuelModel.init()
        
        VStack{
            AddButton()
                .environmentObject(fuelModel)
            FuelListSubView()
                .environmentObject(fuelModel)
            Spacer()
        }
    }
}

struct FuelView_Previews: PreviewProvider {
    static var previews: some View {
        FuelView()
    }
}
