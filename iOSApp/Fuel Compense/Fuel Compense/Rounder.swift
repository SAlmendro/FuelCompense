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
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension String {
    func commaToPoint() -> String {
        return NSString(string: self).replacingOccurrences(of: ",", with: ".")
    }
    
    func pointToComma() -> String {
        return NSString(string: self).replacingOccurrences(of: ".", with: ",")
    }
}
