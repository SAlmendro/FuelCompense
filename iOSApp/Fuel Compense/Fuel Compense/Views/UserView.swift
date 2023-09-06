//
//  UserView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/8/23.
//

import SwiftUI



struct UserView: View {
    
    @EnvironmentObject var userModel : UserModel

    @State var showLogin = false
    @State var showRegister = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(String(localized: "uv.user"))) {
                    if(userModel.notLoggedUser) {
                        Button(action: {
                            showLogin = true
                        }) { Text("login") }
                        Button(action: {
                            showRegister = true
                        }) { Text("register") }
                    } else {
                        HStack {
                            Text(String(localized: "uv.userName"))
                            Spacer()
                            Text(userModel.user.userName)
                        }
                        Button(action: {
                            userModel.logout()
                            // log out (present an alert asking if you want to delete app data also)
                        }) { Text("uv.logout") }
                        Button(action: {
                            userModel.logout()
                            // delete user (present an alert before deleting user)
                        }) { Text("uv.deleteUser") }
                    }
                }
                Section(header: Text(String(localized: "uv.social"))) {
                    NavigationLink(
                        destination: FollowsSubView(followers: true)
                            .environmentObject(userModel)
                    ) {
                        Text(String(localized: "uv.followers") + String(userModel.followers.count) )
                    }
                    NavigationLink(
                        destination: FollowsSubView(followers: false)
                            .environmentObject(userModel)
                    ) {
                        Text(String(localized: "uv.followed") + String(userModel.following.count) )
                    }
                    NavigationLink(
                        destination: SearchUsersSubView()
                            .environmentObject(userModel)
                    ) {
                        Text(String(localized: "uv.searchUsers"))
                    }
                }
            }
        }
        .navigationTitle("uv.profile")
        .sheet(isPresented: $showLogin){
            LoginModal(showLogin: $showLogin)
                .environmentObject(userModel)
        }
        .sheet(isPresented: $showRegister){
            RegisterModal(showRegister: $showRegister)
                .environmentObject(userModel)
        }
    }
}
