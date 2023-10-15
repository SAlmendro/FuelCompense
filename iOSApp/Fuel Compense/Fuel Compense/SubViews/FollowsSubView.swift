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
    @State var showAlert = false
    @State var unfollow = ""
    @State var follow = ""
    @State var title = ""
    
    var body: some View {
        let title = followers ? String(localized: "fsv.followers") : String(localized: "fsv.followed")
        let list = followers ? userModel.followers : userModel.following
        List {
            ForEach(list.indices, id: \.self) { i in
                Button(action: {
                    if followers {
                        if userModel.following.contains(list[i]) {
                            unfollow = list[i]
                            showUnfollowAlert = true
                            showAlert = true
                        } else {
                            follow = list[i]
                            showFollowAlert = true
                            showAlert = true
                        }
                    } else {
                        unfollow = list[i]
                        showUnfollowAlert = true
                        showAlert = true
                    }
                }) { Text(list[i]) }
            }
        }
        .navigationTitle(title)
        .alert(isPresented: $showAlert) {
            if (showUnfollowAlert) {
                return Alert(
                    title: Text(String(localized: "fsv.unfollow")),
                    message: Text(String(localized: "fsv.questionUnfollow") + unfollow),
                    primaryButton: .cancel() {
                        unfollow = ""
                        showUnfollowAlert = false
                        showAlert = false
                    },
                    secondaryButton: .destructive(
                        Text(String(localized: "fsv.unfollow")),
                        action: {
                            userModel.unfollow(userName: unfollow) { success in
                                if success {
                                    unfollow = ""
                                    DispatchQueue.main.async {
                                        userModel.getFollowers()                                    }
                                    showUnfollowAlert = false
                                    showAlert = false
                                } else {
                                    print("Hubo un problema dejando de seguir al usuario " + unfollow)
                                    unfollow = ""
                                    showUnfollowAlert = false
                                    showAlert = false
                                }
                            }
                        }
                    )
                )
            } else {
                return Alert(
                    title: Text(String(localized: "fsv.follow")),
                    message: Text(String(localized: "fsv.questionFollow") + follow),
                    primaryButton: .default(
                        Text(String(localized: "fsv.follow")),
                        action: {
                            userModel.follow(userName: follow) { success in
                                if success {
                                    follow = ""
                                    DispatchQueue.main.async {
                                        userModel.getFollowing()
                                    }
                                    showFollowAlert = false
                                    showAlert = false
                                } else {
                                    print("Hubo un problema siguiendo al usuario " + follow)
                                    follow = ""
                                    showFollowAlert = false
                                    showAlert = false
                                }
                            }
                        }
                    ),
                    secondaryButton: .cancel() {
                        follow = ""
                        showFollowAlert = false
                        showAlert = false
                    }
                )
            }
        }
    }
}
