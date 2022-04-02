//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SocialView: View {
    var body: some View {
        VStack {
            AddButton()
            Spacer()
            Text("Aquí habrá una List mostrando las actualizaciones de estado de tus amigos, cada elemento de la list será una view con el texto del estado y botón de like, al estilo twitter.")
                .padding()
            Spacer()
        }
        
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
