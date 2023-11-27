//
//  String+Extension.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation

// MARK: - Currency Symbol Conversion
/// Extension on String for converting currency codes to symbols
extension String {
    /// Converts currency code (e.g., "USD", "EUR") to symbol (e.g., "$", "€")
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
