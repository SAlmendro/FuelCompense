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
            Text(String(localized: "register"))
            Spacer()
            TextField(String(localized: "uv.userName"), text: $userName)
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                DispatchQueue.global().async {
                    userModel.register(userName: userName) { success in
                        if success {
                            showRegister = false
                        } else {
                            registerIncorrect = true
                        }
                    }
                }
            })  {Text(String(localized: "register"))}
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
