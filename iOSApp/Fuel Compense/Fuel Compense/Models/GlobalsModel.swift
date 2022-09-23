//
//  GlobalsModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 9/4/22.
//

import Foundation

struct Globals: Codable {
    
    var fuelType : String
    var carbonPerLiter : Float
    var lastRefuel : FuelRefill?
    var lastCompensation : CarbonCompensation?
    var kmSinceLastFullRefill : Int
    var partialRefuelingsNotConsolidated : [UUID]
    
}


class GlobalsModel : ObservableObject {
    
    private var globals0 = Globals(
        fuelType: "",
        carbonPerLiter: 0,
        lastRefuel: nil,
        lastCompensation: nil,
        kmSinceLastFullRefill: 0,
        partialRefuelingsNotConsolidated: [])
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var globals : Globals {
        didSet {
            do {
                let data = try encoder.encode(globals)
                UserDefaults.standard.set(data, forKey: "globals")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    
    init(){
        userDef = UserDefaults.standard
        if let globalsUserDefData = (userDef.object(forKey: "globals") as? Data) {
            do {
                let globalsUserDef = try decoder.decode(Globals.self, from: globalsUserDefData)
                self.globals = globalsUserDef
                print("Globals recovered")
            } catch {
                self.globals = globals0
                print(error.localizedDescription)
            }
            
        } else {
            print("There were no globals in userDef")
            self.globals = globals0
        }
    }
    
    func deleteCarData() -> Void {
        globals = Globals(
            fuelType: "",
            carbonPerLiter: 0,
            lastRefuel: nil,
            lastCompensation: self.globals.lastCompensation,
            kmSinceLastFullRefill: 0,
            partialRefuelingsNotConsolidated: [])
    }
    
    func deleteCarbonData() -> Void {
        globals = Globals(
            fuelType: self.globals.fuelType,
            carbonPerLiter: self.globals.carbonPerLiter,
            lastRefuel: nil,
            lastCompensation: self.globals.lastCompensation,
            kmSinceLastFullRefill: 0,
            partialRefuelingsNotConsolidated: [])
    }
    
    func deleteAll() -> Void {
        globals = globals0
    }
    
}
