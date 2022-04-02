//
//  MyForm.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 21/3/22.
//

import SwiftUI

struct MyForm: View {
    
    @State var fieldName : String
    @Binding var fieldNumber : String
    
    var body: some View {
        HStack {
            Text(fieldName)
                .padding()
            TextField(fieldName, text: $fieldNumber)
                .padding()
                .keyboardType(.decimalPad)
        }
        
    }
}
