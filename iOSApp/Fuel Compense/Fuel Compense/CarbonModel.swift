//
//  CarbonModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct CarbonCompensation: Codable {
    
    let id: Int
    var date: Date
    var tons: Float
    
}


class CarbonModel : ObservableObject {
    
    @Published var compensations = [CarbonCompensation]()
    
    /* Se crean la base y el token. Se crea la URLSession desde la que se va a
     *   controlar todo el proceso de consulta a la API.
     */
    
    
    let urlBase = ""
    let TOKEN = ""
    let session = URLSession.shared
    
   
}
