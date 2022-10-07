//
//  FuelModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct FuelRefill: Codable, Comparable {
    
    var id = UUID()
    var odometer : Int
    var liters : Float
    var eurosLiter : Float
    var total : Float
    var date : Date
    var fullTank : Bool
    var totalCarbon : Float
    
    static func <(lhs: FuelRefill, rhs: FuelRefill) -> Bool {
            return lhs.odometer < rhs.odometer
    }
    
    
}


class FuelModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var refills : Array<FuelRefill> {
        didSet {
            do {
                let data = try encoder.encode(refills)
                UserDefaults.standard.set(data, forKey: "refuelings")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    
    init(){
        userDef = UserDefaults.standard
        if let refillsUserDefData = (userDef.object(forKey: "refuelings") as? Data) {
            do {
                let refillsUserDef = try decoder.decode(Array<FuelRefill>.self, from: refillsUserDefData)
                self.refills = refillsUserDef
                print("Refuelings recovered")
            } catch {
                self.refills = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no refuelings in userDef")
            self.refills = []
        }
    }
    
    func delete(uuid: UUID) -> Bool {
        if refills.last!.id == uuid {
            refills.removeLast()
            return true;
        }
        return false;
    }
    
    func deleteAll() -> Void {
        refills = []
    }
    
}
