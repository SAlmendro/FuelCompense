//
//  UserView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/8/23.
//

import SwiftUI



struct UserView: View {
    
    @EnvironmentObject var userModel : UserModel
    @EnvironmentObject var fuelModel : FuelModel
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var statusModel : StatusModel

    @State var showLogin = false
    @State var showRegister = false
    @State var showLogoutAlert = false
    
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
                            showLogoutAlert = true
                        }) { Text("uv.logout") }
                            .alert(isPresented: $showLogoutAlert) {
                                Alert(title: Text(String(localized: "uv.logoutAlertTitle")),
                                      message: Text(String(localized: "uv.logoutAlertMessage")),
                                      primaryButton: .default(
                                        Text(String(localized: "uv.notDeleteLocalData")),
                                        action: {
                                            userModel.logout()
                                        }),
                                      secondaryButton: .destructive(
                                        Text(String(localized: "uv.deleteLocalData")),
                                        action: {
                                            userModel.logout()
                                            fuelModel.deleteAllLocal()
                                            carbonModel.deleteAllLocal()
                                            statusModel.deleteAllLocal()
                                        }
                                    )
                                )
                            }
                        Button(action: {
                            userModel.logout()
                            // delete user (present an alert before deleting user)
                        }) { Text("uv.deleteUser") }
                    }
                }
                if (!userModel.notLoggedUser) {
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
