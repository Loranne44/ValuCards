//
//  NumberFormatter+Extensions.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation

extension NumberFormatter {
    /// Formats a Double value as a price string
    static func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "NB" }
        return String(format: "%.2f", price)
    }
}
