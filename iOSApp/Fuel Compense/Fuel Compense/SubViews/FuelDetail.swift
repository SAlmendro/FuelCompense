//
//  FuelDetail.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import SwiftUI

struct FuelDetail: View {
    
    @Binding var fuelRefill : FuelRefill
    
    var body: some View {
        
        Text("Here we'll have a detail of the refill and a button to delete it if it is the last one.")
        
    }
}
