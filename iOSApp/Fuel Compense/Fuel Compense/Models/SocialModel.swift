//
//  SocialModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation

struct SocialUnit : Codable {
    
    var id = UUID()
    var text : String
    var favs : Array<String> // the strings are the usernames of the users that marked this social unit as fav
    var authUserName : String
    var authID : Int
    
}

class SocialModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var socialUnits : Array<SocialUnit>
    
    init(){
        socialUnits = []
        // retrieve the social units from the API, if there is no social units, the API will return a 204, and we will create the array empty
    }
    
    func refresh() -> Void {
        // retrieve the social units from the API
    }
    
    func publish(socialUnit: SocialUnit) -> Void {
        socialUnits.append(socialUnit);
        // publish the new social unit to the API and then, retrieve the social units to have it complete
    }
    
    func delete(uuid: UUID) -> Bool {
        let index = socialUnits.firstIndex { su in
            su.id == uuid;
        }!
        socialUnits.remove(at: index);
        // delete the social unit from the API, returns true if delete was succesfull
        return true;
    }
    
}
