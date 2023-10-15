//
//  SearchUsersSubView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 6/9/23.
//

import SwiftUI

struct SearchUsersSubView: View {
    @EnvironmentObject var userModel : UserModel
    @State private var keyword = ""
    @State private var searchResults: [String] = []
    @State private var showFollowAlert = false
    @State private var showFollowNotSuccessAlert = false
    @State private var selectedResult = ""

    var body: some View {
        VStack {
            TextField(String(localized: "susv.searchUser"), text: $keyword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                searchResults = userModel.searchUsers(keyword: keyword)
            }) {
                Text(String(localized: "search"))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            List(searchResults, id: \.self) { result in
                Button(action: {
                    selectedResult = result
                    showFollowAlert = true
                }) {
                    Text(result)
                }
            }
        }
        .alert(isPresented: $showFollowAlert) {
            if (userModel.following.contains(selectedResult)) {
                return Alert(
                    title: Text(String(localized: "fsv.alreadyFollowing")),
                    message: Text(String(localized: "fsv.alreadyFollowingMessage")),
                    dismissButton: .cancel() {
                        selectedResult = ""
                        showFollowAlert = false
                    }
                )
            } else {
                return Alert(
                    title: Text(String(localized: "fsv.follow")),
                    message: Text(String(localized: "fsv.questionFollow") + selectedResult),
                    primaryButton: .default(
                        Text(String(localized: "fsv.follow")),
                        action: {
                            userModel.follow(userName: selectedResult) { success in
                                DispatchQueue.main.async {
                                    if success {
                                        selectedResult = ""
                                        showFollowAlert = false
                                    } else {
                                        print("Ha habido un problema siguiendo al usuario " + selectedResult)
                                        selectedResult = ""
                                        showFollowAlert = false
                                    }
                                }
                            }
                        }
                    ),
                    secondaryButton: .cancel() {
                        selectedResult = ""
                        showFollowAlert = false
                    }
                )
            }
        }
    }
}
