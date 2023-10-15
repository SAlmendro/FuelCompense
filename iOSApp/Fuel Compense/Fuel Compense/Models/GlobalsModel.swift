//
//  GlobalsModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 9/4/22.
//

import Foundation

enum FuelType: Float, Equatable, CaseIterable, Hashable{
    case gasoline = 2.32
    case gasoil = 2.6
}

struct Globals: Codable {
    
    var carbonPerLiter : Float
    
}


class GlobalsModel : ObservableObject {
    
    private var globals0 = Globals(
        carbonPerLiter: 0)
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    let session = URLSession.shared
    var urlBase = "http://192.168.1.101:8080/"
    
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
    
    func deleteAll() -> Void {
        globals = globals0
    }
    
}
