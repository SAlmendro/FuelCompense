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
                    ) {
                        HStack {
                            Text(String(localized: "uv.followers"))
                            Spacer()
                            Text(String(userModel.nFollowers))
                        }
                    }
                    NavigationLink(
                        destination: FollowsSubView(followers: false)
                    ) {
                        HStack {
                            Text(String(localized: "uv.followed"))
                            Spacer()
                            Text(String(userModel.nFollowing))
                        }
                    }
                    NavigationLink(
                        destination: SearchUsersSubView()
                    ) {
                        Text(String(localized: "uv.searchUsers"))
                    }
                }
            }
        }
        .navigationTitle("uv.profile")
        .sheet(isPresented: $showLogin){
            LoginModal(showLogin: $showLogin)
        }
        .sheet(isPresented: $showRegister){
            RegisterModal(showRegister: $showRegister)
        }
        .onAppear{
            print("Estoy apareciendo, soy UserView")
            userModel.getFollowers()
            userModel.getFollowing()
        }
    }
}
