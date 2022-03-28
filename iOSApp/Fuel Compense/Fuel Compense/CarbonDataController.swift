//
//  CarbonDataController.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 28/3/22.
//

import CoreData
import SwiftUI
import Foundation

class CarbonDataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "CarbonCompense")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data error: \(error.localizedDescription)")
            }
        }
    }
    
}
