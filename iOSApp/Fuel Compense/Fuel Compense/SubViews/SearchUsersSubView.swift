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
            Alert(
                title: Text(String(localized: "fsv.follow")),
                message: Text(String(localized: "fsv.questionFollow") + selectedResult),
                primaryButton: .default(
                    Text(String(localized: "fsv.follow")),
                    action: {
                        userModel.follow(userName: selectedResult) { success in
                            if success {
                                selectedResult = ""
                            } else {
                                showFollowNotSuccessAlert = true
                            }
                        }
                    }
                ),
                secondaryButton: .cancel() {}
               
            )
        }
        .alert(isPresented: $showFollowNotSuccessAlert) {
            Alert(
                title: Text(String(localized: "fsv.unfollowNotSuccess")),
                message: Text(String(localized: "fsv.errorInUnfollowing") + selectedResult),
                dismissButton: .cancel() {}
            )
        }
    }
}
