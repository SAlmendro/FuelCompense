//
//  FuelModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct FuelRefill: Codable {
    
    var id = UUID()
    var odometer: Int
    var trip: Int
    var liters: Float
    var eurosLiter: Float
    var total: Float
    var date: Date
    var fullTank: Bool
    var meanConsume: Float
    var meanEmissions: Float
    var totalCarbon: Float
    var previousRefill: UUID
    
}


class FuelModel : ObservableObject {
    
    @Published var refills = [FuelRefill]()
    
    func delete(uuid: UUID) -> Bool {
        if refills.last!.id == uuid {
            refills.popLast()
            return true;
        }
        return false;
    }
    
}
