//
//  SocialView.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct StatusView: View {
    
    @EnvironmentObject var statusModel : StatusModel
    @State var myStatuses : Bool = false
    @State var showDeleteAllAlert = false
    
    var body: some View {
        VStack{
            RefreshButton(title: String(localized: "stv.title"))
            NavigationView{
                VStack {
                    Toggle(isOn: $myStatuses) {
                        Text(String(localized: "stv.myStatuses"))
                    }
                    .padding()
                    if (!statusModel.unpublishedStatuses.isEmpty) {
                        Button(action: {
                            DispatchQueue.global().async {
                                statusModel.uploadUnpublished()
                            }
                        }) {
                            Text(String(localized: "stv.retryUpload"))
                        }
                        .padding()
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                    }
                    List {
                        if (myStatuses) {
                            ForEach(statusModel.statuses.indices, id: \.self) { i in
                                NavigationLink(
                                    destination: StatusDetail(status: $statusModel.statuses[i])
                                ) {
                                    StatusRow(status: $statusModel.statuses[i])
                                }
                            }
                        } else {
                            ForEach(statusModel.subscribedStatuses.indices, id: \.self) { i in
                                NavigationLink(
                                    destination: StatusDetail(status: $statusModel.subscribedStatuses[i])
                                ) {
                                    StatusRow(status: $statusModel.subscribedStatuses[i])
                                }
                            }
                        }
                    }
                    if (myStatuses) {
                        Button(action: {
                            showDeleteAllAlert = true
                        }) {
                            Text(String(localized: "stv.deleteAll"))
                        }
                        .padding()
                        .foregroundColor(Color(uiColor: .red))
                        .alert(isPresented: $showDeleteAllAlert) {
                            Alert(
                                title: Text(String(localized: "stv.deleteAll")),
                                message: Text(String(localized: "stv.deleteAllMessage")),
                                primaryButton: .cancel() {},
                                secondaryButton: .destructive(
                                    Text(String(localized: "delete")),
                                    action: {
                                        DispatchQueue.global().async {
                                            statusModel.deleteAll()
                                        }
                                    }
                                )
                            )
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear{
            DispatchQueue.global().async {
                statusModel.getSubscribedStatuses()
            }
        }
    }
    
}


