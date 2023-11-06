//
//  CompenseModal.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 19/3/22.
//

import SwiftUI

struct CompenseModal: View {
    
    @EnvironmentObject var carbonModel : CarbonModel
    @EnvironmentObject var globalsModel : GlobalsModel
    @EnvironmentObject var statusModel : StatusModel
    @EnvironmentObject var userModel : UserModel
    @Binding var showCompenseModal: Bool
    @State var date = Date()
    @State var CO2tons = ""
    @State var comment = ""
    @State var status = ""
    var editMode : Bool
    var index = 0
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField(String(localized: "cm.tons"), text: $CO2tons)
                        .keyboardType(.decimalPad)
                    TextField(String(localized: "cm.comment"), text: $comment)
                    DatePicker(String(localized: "date"), selection: $date)
                }
                Section {
                    TextField(String(localized: "cm.status"), text: $status)
                }
                Section {
                    if (CO2tons != "" &&
                        Float(CO2tons.commaToPoint()) != Float(0) && 
                        (editMode && (Float(CO2tons.commaToPoint()) != carbonModel.compensations[index].tons))) {
                        HStack{
                            Spacer()
                            if (editMode) {
                                Button(action: {
                                    carbonModel.compensations[index].tons = Float(CO2tons.commaToPoint())!
                                    carbonModel.compensations[index].date = date
                                    DispatchQueue.global().async {
                                        carbonModel.updateCompensation(compensation: carbonModel.compensations[index])
                                    }
                                    let compensationsTemp = carbonModel.compensations
                                    let compensationsSorted = compensationsTemp.sorted(by: { (com0: Compensation, com1: Compensation) -> Bool in
                                        return com0 < com1
                                    })
                                    carbonModel.compensations = compensationsSorted
                                    self.showCompenseModal = false
                                }) {Text(String(localized: "save"))}
                            } else {
                                Button(action: {
                                    let compensation = Compensation(
                                        comment: comment,
                                        date: date,
                                        tons: Float(CO2tons.commaToPoint())!
                                    )
                                    DispatchQueue.global().async {
                                        carbonModel.publishCompensation(compensation: compensation)
                                    }
                                    self.showCompenseModal = false
                                }) {Text(String(localized: "add"))}
                            }
                            Spacer()
                            if (editMode) {
                                Button(action: {
                                    let status = Status(text: status, authUserName: userModel.user.userName)
                                    carbonModel.compensations[index].tons = Float(CO2tons.commaToPoint())!
                                    carbonModel.compensations[index].date = date
                                    DispatchQueue.global().async {
                                        carbonModel.updateCompensation(compensation: carbonModel.compensations[index])
                                        statusModel.publish(status: status)
                                    }
                                    let compensationsTemp = carbonModel.compensations
                                    let compensationsSorted = compensationsTemp.sorted(by: { (com0: Compensation, com1: Compensation) -> Bool in
                                        return com0 < com1
                                    })
                                    carbonModel.compensations = compensationsSorted
                                    self.showCompenseModal = false
                                }) {Text(String(localized: "saveAndPublish"))}
                            } else {
                                Button(action: {
                                    let status = Status(text: status, authUserName: userModel.user.userName)
                                    let compensation = Compensation(
                                        comment: comment,
                                        date: date,
                                        tons: Float(CO2tons.commaToPoint())!
                                    )
                                    DispatchQueue.global().async {
                                        carbonModel.publishCompensation(compensation: compensation)
                                        statusModel.publish(status: status)
                                    }
                                    self.showCompenseModal = false
                                }) {Text(String(localized: "addAndPublish"))}
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showCompenseModal = false
                        }) {Text(String(localized: "cancel"))}
                        .buttonStyle(BorderlessButtonStyle())
                        Spacer()
                    }
                }
            }
        }
    }
}
