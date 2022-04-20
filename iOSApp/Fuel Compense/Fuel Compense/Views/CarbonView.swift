//
//  CarbonView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CarbonView: View {
    
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    
    var body: some View {
        NavigationView {
            
        }
        .navigationTitle(String(localized: "cav.title"))
    }
}

struct CarbonView_Previews: PreviewProvider {
    static var previews: some View {
        CarbonView()
    }
}
