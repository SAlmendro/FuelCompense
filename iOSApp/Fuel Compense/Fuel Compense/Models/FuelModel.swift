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

struct FullTankData {
    
    var fullKm : Int
    var fullLiters : Float
    var fullCO2 : Float
    var meanConsume : Float
    var meanEmissions : Float
    
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
    
    func delete(index: Int) -> Void {
        refills.remove(at: index)
    }
    
    func deleteAll() -> Void {
        refills = []
    }
    
    func getTrip(i: Int) -> Int {
        if (refills.count == i+1) {
            return 0
        }
        return refills[i].odometer - refills[i+1].odometer
    }
    
    public func getFullTankData(i: Int) -> FullTankData {
        if (i+1 == refills.count) {
            return FullTankData(
                fullKm: getTrip(i: i),
                fullLiters: refills[i].liters,
                fullCO2: refills[i].totalCarbon,
                meanConsume: 0,
                meanEmissions: 0
                )
        }
        var partial = !refills[i+1].fullTank
        let fullKm = getTrip(i: i)
        let fullLiters = refills[i].liters
        let fullCO2 = refills[i].totalCarbon
        var fullTankData = FullTankData(
            fullKm: fullKm,
            fullLiters: fullLiters,
            fullCO2: fullCO2,
            meanConsume: (fullLiters / Float(fullKm))*100,
            meanEmissions: (fullCO2 / Float(fullKm))*100
            )
        var index = i+1
        while(partial) {
            fullTankData.fullKm += getTrip(i: index)
            fullTankData.fullLiters += refills[index].liters
            fullTankData.fullCO2 += refills[index].totalCarbon
            fullTankData.meanConsume = (fullTankData.fullLiters / Float(fullTankData.fullKm))*100
            fullTankData.meanEmissions = (fullTankData.fullCO2 / Float(fullTankData.fullKm))*100
            index += 1
            if (index == refills.count) {
                return fullTankData
            }
            partial = !refills[index].fullTank
        }
        return fullTankData
    }
    
}
