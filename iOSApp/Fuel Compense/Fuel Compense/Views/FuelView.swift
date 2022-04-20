//
//  FuelView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    
    var body: some View {
        
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
