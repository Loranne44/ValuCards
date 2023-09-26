//
//  Extension.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/08/2023.
//

import Foundation

// MARK: - Currency Symbol Conversion
extension String {
    func currencySymbol() -> String {
        switch self {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        case "CHF":
            return "CHF"
        case "JPY":
            return "¥"
        case "CAD":
            return "CA$"
        case "AUD":
            return "A$"
        default:
            return self
        }
    }
}

