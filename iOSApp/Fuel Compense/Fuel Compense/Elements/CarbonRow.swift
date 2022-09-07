//
//  CarbonRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import Foundation
import SwiftUI

struct CarbonRow: View {

    @Binding var carbonCompensation : CarbonCompensation
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(carbonCompensation.tons) tons compensed")
            Spacer()
            Text("\(carbonCompensation.date)")
        }
        
    }
}
