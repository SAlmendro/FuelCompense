//
//  LoginModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 6/5/23.
//

import SwiftUI

struct LoginModal: View {
    
    @Binding var showLogin : Bool
    @EnvironmentObject var userModel : UserModel
    @State var userName : String = ""
    @State var loginIncorrect : Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(localized: "lm.login"))
            Spacer()
            TextField(String(localized: "lm.userName"), text: $userName)
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: {
                DispatchQueue.global().async {
                    userModel.login(userName: userName) { success in
                        if success {
                            showLogin = false
                        } else {
                            loginIncorrect = true
                        }
                    }
                }
            }) {
                Text(String(localized: "lm.login"))
            }
            Spacer()
            if (loginIncorrect) {
                Text(String(localized: "lm.loginIncorrect"))
                    .padding()
                    .bold()
                    .foregroundColor(Color(uiColor: .red))
                Spacer()
            }
        }
    }

}
