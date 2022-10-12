//
//  CarbonModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct CarbonCompensation: Codable, Comparable {
    
    var id = UUID()
    var date : Date
    var tons : Float
    
    static func <(lhs: CarbonCompensation, rhs: CarbonCompensation) -> Bool {
        return lhs.date.compare(rhs.date).rawValue > 0
    }
    
}


class CarbonModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var compensations : Array<CarbonCompensation> {
        didSet {
            do {
                let data = try encoder.encode(compensations)
                UserDefaults.standard.set(data, forKey: "compensations")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var userDef : UserDefaults
    
    init(){
        userDef = UserDefaults.standard
        if let compensationsUserDefData = (userDef.object(forKey: "compensations") as? Data) {
            do {
                let compensationsUserDef = try decoder.decode(Array<CarbonCompensation>.self, from: compensationsUserDefData)
                self.compensations = compensationsUserDef
                print("Compensations recovered")
            } catch {
                self.compensations = []
                print(error.localizedDescription)
            }
        } else {
            print("There were no compensations in userDef")
            self.compensations = []
        }
    }
    
    func delete(index: Int) -> Void {
        compensations.remove(at: index)
    }
    
    func deleteAll() -> Void {
        compensations = []
    }
    
    public func getTotalCompensedInKg() -> Float {
        var totalCompensed = Float(0)
        if compensations.isEmpty {
            return totalCompensed
        }
        for compensation in compensations {
            totalCompensed += compensation.tons
        }
        return totalCompensed*1000
    }
   
}
