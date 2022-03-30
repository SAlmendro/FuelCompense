//
//  FuelModel.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 30/3/22.
//

import Foundation


struct FuelRefill: Codable {
    
    let id: Int
    var odometer: Int
    var liters: Float
    var eurosLiter: Float
    var total: Float
    var date: Date
    var fullTank: Bool
    var totalCarbon: Float
    
}


class FuelModel : ObservableObject {
    
    @Published var refills = [FuelRefill]()
    
    /* Se crean la base y el token. Se crea la URLSession desde la que se va a
     *   controlar todo el proceso de consulta a la API.
     */
    
    
    let urlBase = ""
    let TOKEN = ""
    let session = URLSession.shared
    
   
}
