//
//  CarbonView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CarbonView: View {
    var body: some View {
        VStack {
            AddButton()
            Spacer()
            Text("Aquí habrá un picker en la parte de arriba para seleccionar o una vista de estadísticas de contaminación (donde se mostrará un mensaje con el CO2 neto actual y la opción de compensar si ese CO2 es positivo) o una lista de las compensaciones.")
                .padding()
            Spacer()
        }
        
    }
}

struct CarbonView_Previews: PreviewProvider {
    static var previews: some View {
        CarbonView()
    }
}
