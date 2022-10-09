//
//  Rounder.swift
//  Fuel Compense
//
//  Created by Sergio Almendro Cerdá on 9/10/22.
//

import Foundation

extension Float {
    func round(amountOfDecimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = amountOfDecimals
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
