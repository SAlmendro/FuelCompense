//
//  SettingsView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct SettingsView: View {

    @State var name: String = ""
    @State var isFree: Bool = true
    @State var prefEnabled: Bool = false
    @State private var pIndex = 0
    let prefs = ["Gasolina", ""]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("PERFIL")) {
                    TextField("Nombre", text: $name)
                    Toggle(isOn: $isFree) { Text("Gratis") }
                }
                Section(header: Text("PPREFERENCIAS")) {
                    Toggle(isOn: $prefEnabled) { Text("Habilitar") }
                    Picker(selection: $pIndex, label: Text("Opciones")) {
                        ForEach(0 ..< prefs.count) {
                            Text(prefs[$0])
                        }
                    }
                }
                Section(header: Text("ABOUT")) {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text("1.2.1")
                    }
                    Text("En Ajustes irá el inicio de sesión en el perfil del usuario, y otros ajustes como mostrar en l/100km o galones/100millas, etc.")
                    Text("Esta página de ajustes es sólo una plantilla para hacer la futura página de ajustes")
                    Text(name)
                }
                Section {
                    Button(action: { }) { Text("Refrescar") }
                }
            }
            .navigationTitle("cv.settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
