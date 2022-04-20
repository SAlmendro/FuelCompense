//
//  CarbonModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct CarbonCompensation: Codable {
    
    let id : Int
    var date : Date
    var tons : Float
    var currentCarbonNet : Float
    
}


class CarbonModel : ObservableObject {
    
    @Published var compensations = [CarbonCompensation]()
   
}
