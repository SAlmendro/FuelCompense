//
//  RegisterModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 28/8/23.
//

import SwiftUI

struct RegisterModal: View {
    
    @Binding var showRegister : Bool
    @EnvironmentObject var userModel : UserModel
    @State var userName : String = ""
    @State var registerIncorrect : Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(localized: "rm.register"))
            Spacer()
            TextField(String(localized: "rm.userName"), text: $userName)
            Spacer()
            Button(action: {
                if userModel.register(userName: userName) {
                    showRegister = false
                } else {
                    registerIncorrect = true
                }
            })  {Text(String(localized: "rm.register"))}
            Spacer()
            if (registerIncorrect) {
                Text(String(localized: "rm.registerIncorrect"))
                    .padding()
                    .bold()
                    .foregroundColor(Color(uiColor: .red))
                Spacer()
            }
        }
    }

}
