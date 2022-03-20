//
//  FuelView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct FuelView: View {
    var body: some View {
        VStack{
            AddButton()
            Spacer()
            Text("Aquí habrá un picker en la parte de arriba para seleccionar o una vista de estadísticas de consumo o una lista de los repostajes.")
                .padding()
            Spacer()
        }
    }
}

struct FuelView_Previews: PreviewProvider {
    static var previews: some View {
        FuelView()
    }
}
