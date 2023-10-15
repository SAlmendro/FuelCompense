//
//  FuelModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct Refill: Codable, Comparable {
    
    var id = UUID()
    var odometer : Int
    var liters : Float
    var eurosLiter : Float
    var total : Float
    var date : Date
    var fullTank : Bool
    var totalCarbon : Float
    
    static func <(lhs: Refill, rhs: Refill) -> Bool {
            return lhs.odometer < rhs.odometer
    }
    
    
}

struct FullTankData {
    
    var fullKm : Int
    var fullLiters : Float
    var fullCO2 : Float
    var totalEur : Float
    var meanConsume : Float
    var meanEmissions : Float
    var meanEur : Float
    
}


class FuelModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var refills : Array<Refill> {
        didSet {
            do {
                let data = try encoder.encode(refills)
                UserDefaults.standard.set(data, forKey: "refills")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var unpublishedRefills : Array<Refill> {
        didSet {
            do {
                let data = try encoder.encode(unpublishedRefills)
                UserDefaults.standard.set(data, forKey: "unpublishedRefills")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    var globalsModel : GlobalsModel
    var userModel : UserModel
    let refillAPI = "refills/"
    
    init(globalsModel: GlobalsModel, userModel: UserModel){
        userDef = UserDefaults.standard
        self.globalsModel = globalsModel
        self.userModel = userModel
        if let refillsUserDefData = (userDef.object(forKey: "refills") as? Data) {
            do {
                let refillsUserDef = try decoder.decode(Array<Refill>.self, from: refillsUserDefData)
                self.refills = refillsUserDef
                print("Refills recovered")
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
        if (refills.count == i+1 || getNumberOfFullTanks() < 2 || refills.count < 2) {
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
                totalEur: refills[i].total,
                meanConsume: 0,
                meanEmissions: 0,
                meanEur: 0
                )
        }
        var partial = !refills[i+1].fullTank
        let fullKm = getTrip(i: i)
        let fullLiters = refills[i].liters
        let fullCO2 = refills[i].totalCarbon
        let totalEur = refills[i].total
        var fullTankData = FullTankData(
            fullKm: fullKm,
            fullLiters: fullLiters,
            fullCO2: fullCO2,
            totalEur: totalEur,
            meanConsume: (fullLiters / Float(fullKm))*100,
            meanEmissions: (fullCO2 / Float(fullKm))*100,
            meanEur: (totalEur / Float(fullKm))*100
            )
        var index = i+1
        while(partial) {
            fullTankData.fullKm += getTrip(i: index)
            fullTankData.fullLiters += refills[index].liters
            fullTankData.fullCO2 += refills[index].totalCarbon
            fullTankData.totalEur += refills[index].total
            fullTankData.meanConsume = (fullTankData.fullLiters / Float(fullTankData.fullKm))*100
            fullTankData.meanEmissions = (fullTankData.fullCO2 / Float(fullTankData.fullKm))*100
            fullTankData.meanEur = (fullTankData.totalEur / Float(fullTankData.fullKm))*100
            index += 1
            if (index == refills.count) {
                return fullTankData
            }
            partial = !refills[index].fullTank
        }
        print(fullTankData.meanEmissions)
        return fullTankData
    }
    
    public func getAverageEmissions() -> Float {
        let totalEmissions = getTotalEmissions()
        if totalEmissions == 0 {
            return Float(0)
        }
        print("total emissions: \(totalEmissions)")
        let totalKm = getTotalKm()
        print("total km: \(totalKm)")
        if totalKm < 1 {
            return Float(0)
        }
        return (totalEmissions/Float(totalKm))*100
    }
    
    public func getTotalEmissions() -> Float {
        var totalEmissions = Float(0)
        for refill in refills {
            totalEmissions += refill.totalCarbon
        }
        return totalEmissions
    }
    
    public func getTotalConsume() -> Float {
        var totalConsume = Float(0)
        for i in refills.indices {
            totalConsume += refills[i].liters
        }
        return totalConsume
    }
    
    public func getTotalKm() -> Int {
        if refills.count < 2 {
            return 0
        }
        return refills[0].odometer - refills[refills.count - 1].odometer
    }
    
    public func getTotalEur() -> Float {
        var totalEur = Float(0)
        for i in refills.indices {
            totalEur += refills[i].total
        }
        return totalEur
    }
    
    public func getAverageConsume() -> Float {
        let totalKm = getTotalKm()
        if totalKm < 1 {
            return Float(0)
        }
        return (getTotalConsume()/Float(totalKm))*100
    }
    
    public func getAverageEur() -> Float {
        let totalKm = getTotalKm()
        if totalKm < 1 {
            return Float(0)
        }
        return (getTotalEur()/Float(totalKm))*100
    }
    
    public func getNumberOfFullTanks() -> Int {
        var n = 0;
        for refill in refills {
            if refill.fullTank {
                n += 1
            }
        }
        return n
    }
    
}
