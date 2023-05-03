//
//  SocialModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 11/5/22.
//

import Foundation

struct Status : Codable {
    
    var id : Int64
    var text : String
    var favs : Array<String> // the strings are the usernames of the users that marked this social unit as fav
    var authUserName : String
    var creationDate : Date
    
}

class SocialModel : ObservableObject {
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    @Published var statuses : Array<Status>
    
    init(){
        statuses = []
        // retrieve the social units from the API, if there is no social units, the API will return a 200 with an empty array
    }
    
    func refresh() -> Void {
        // retrieve the social units from the API
    }
    
    func publish(status: Status) -> Void {
        // publish the new social unit to the API and then, retrieve the social units to have it complete.
        // statuses.append(status); append the status received from the API, as it has the creationDate
        refresh()
    }
    
    func delete(id: Int64) -> Bool {
        let index = statuses.firstIndex { su in
            su.id == id;
        }!
        statuses.remove(at: index);
        // delete the social unit from the API, returns true if delete was succesfull
        return true;
    }
    
}
