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
    @EnvironmentObject var globalsModel : GlobalsModel

    @State var showLogin = false
    @State var showRegister = false
    @State var showLogoutAlert = false
    @State var showDeleteAlert = false
    
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
                                Alert(title: Text(String(localized: "uv.logout")),
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
                                            globalsModel.deleteAll()
                                        }
                                    )
                                )
                            }
                        Button(action: {
                            showDeleteAlert = true
                        }) { Text("uv.deleteUser") }
                            .alert(isPresented: $showDeleteAlert) {
                                Alert(title: Text(String(localized: "uv.deleteUser")),
                                      message: Text(String(localized: "uv.deleteAlertMessage")),
                                      primaryButton: .cancel(),
                                      secondaryButton: .destructive(
                                        Text(String(localized: "uv.deleteUser")),
                                        action: {
                                            if userModel.delete() {
                                                fuelModel.deleteAllLocal()
                                                carbonModel.deleteAllLocal()
                                                statusModel.deleteAllLocal()
                                                globalsModel.deleteAll()
                                            }
                                        }
                                    )
                                )
                            }
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
            .navigationTitle("uv.profile")
        }
        .sheet(isPresented: $showLogin){
            LoginModal(showLogin: $showLogin)
        }
        .sheet(isPresented: $showRegister){
            RegisterModal(showRegister: $showRegister)
        }
        .onAppear{
            DispatchQueue.global().async {
                userModel.getFollowers()
                userModel.getFollowing()
            }
        }
    }
}
