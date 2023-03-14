//
//  CarbonRow.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 2/4/22.
//

import Foundation
import SwiftUI

struct CarbonRow: View {
    
    @Binding var compensation : Compensation
    
    var body: some View {
        HStack {
            Spacer()
            Text(compensation.tons.round(amountOfDecimals: 3) + String(localized: "cr.tonsCompensed"))
            Spacer()
            Text("\(compensation.date.formatted(.dateTime.day().month(.twoDigits).year()))")
        }
        
    }
}
