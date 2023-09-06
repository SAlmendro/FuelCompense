//
//  FollowsSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 6/9/23.
//

import SwiftUI

struct FollowsSubView: View {
    
    @EnvironmentObject var userModel : UserModel
    var followers : Bool
    @State var showUnfollowAlert = false
    @State var showFollowAlert = false
    @State var showUnfollowNotSuccessAlert = false
    @State var showFollowNotSuccessAlert = false
    @State var unfollow = ""
    @State var follow = ""
    @State var title = ""
    
    var body: some View {
        let title = followers ? String(localized: "fsv.followers") : String(localized: "fsv.followed")
        let list = followers ? userModel.followers : userModel.following
        NavigationView{
            List {
                ForEach(list.indices, id: \.self) { i in
                    Button(action: {
                        print("boton pulsado")
                        if followers {
                            print("pulsado en followers")
                            follow = list[i]
                            showFollowAlert = true
                            print("showFollowAlert=" + String(showFollowAlert))
                        } else {
                            print("pulsado en following")
                            unfollow = list[i]
                            showUnfollowAlert = true
                            print("showUnfollowAlert=" + String(showUnfollowAlert))
                        }
                    }) { Text(list[i]) }
                        .alert(isPresented: $showUnfollowAlert) {
                            Alert(
                                title: Text(String(localized: "fsv.unfollow")),
                                message: Text(String(localized: "fsv.questionUnfollow") + unfollow),
                                primaryButton: .cancel() {},
                                secondaryButton: .destructive(
                                    Text(String(localized: "fsv.unfollow")),
                                    action: {
                                        userModel.unfollow(userName: unfollow) { success in
                                            if success {
                                                unfollow = ""
                                            } else {
                                                showUnfollowNotSuccessAlert = true
                                            }
                                        }
                                    }
                                )
                            )
                        }
                        .alert(isPresented: $showFollowAlert) {
                            Alert(
                                title: Text(String(localized: "fsv.follow")),
                                message: Text(String(localized: "fsv.questionFollow") + unfollow),
                                primaryButton: .default(
                                    Text(String(localized: "fsv.follow")),
                                    action: {
                                        userModel.follow(userName: follow) { success in
                                            if success {
                                                follow = ""
                                            } else {
                                                showFollowNotSuccessAlert = true
                                            }
                                        }
                                    }
                                ),
                                secondaryButton: .cancel() {}
                               
                            )
                        }
                        .alert(isPresented: $showUnfollowNotSuccessAlert) {
                            Alert(
                                title: Text(String(localized: "fsv.unfollowNotSuccess")),
                                message: Text(String(localized: "fsv.errorInUnfollowing") + unfollow),
                                dismissButton: .cancel() {}
                            )
                        }
                }
            }
        }
        .navigationTitle(title)

    }
}
