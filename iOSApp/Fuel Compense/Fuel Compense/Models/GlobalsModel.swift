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
    var totalLiters : Float
    var totalKm : Int
    var totalKmCarbon : Int
    var totalCarbon : Float
    var netCarbon : Float
    var meanConsume : Float
    var meanEmissions : Float
    var lastRefuel : FuelRefill?
    var lastCompensation : CarbonCompensation?
    var kmSinceLastFullRefill : Int
    var partialRefuelingsNotConsolidated : [UUID]
    
}


class GlobalsModel : ObservableObject {
    
    private var globals0 = Globals(
        fuelType: "",
        carbonPerLiter: 0,
        totalLiters: 0,
        totalKm: 0,
        totalKmCarbon: 0,
        totalCarbon: 0,
        netCarbon: 0,
        meanConsume: 0,
        meanEmissions: 0,
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
            totalLiters: 0,
            totalKm: 0,
            totalKmCarbon: self.globals.totalKmCarbon,
            totalCarbon: self.globals.totalCarbon,
            netCarbon: self.globals.netCarbon,
            meanConsume: 0,
            meanEmissions: self.globals.meanEmissions,
            lastRefuel: nil,
            lastCompensation: self.globals.lastCompensation,
            kmSinceLastFullRefill: 0,
            partialRefuelingsNotConsolidated: [])
    }
    
    func deleteCompensations() -> Void {
        globals = Globals(
            fuelType: self.globals.fuelType,
            carbonPerLiter: 0,
            totalLiters: self.globals.totalLiters,
            totalKm: self.globals.totalKm,
            totalKmCarbon: 0,
            totalCarbon: 0,
            netCarbon: 0,
            meanConsume: 0,
            meanEmissions: self.globals.meanEmissions,
            lastRefuel: nil,
            lastCompensation: self.globals.lastCompensation,
            kmSinceLastFullRefill: 0,
            partialRefuelingsNotConsolidated: [])
    }
    
    func deleteAll() -> Void {
        globals = globals0
    }
    
}
