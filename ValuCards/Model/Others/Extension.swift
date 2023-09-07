//
//  Extension.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/08/2023.
//

import Foundation

extension String {
    func currencySymbol() -> String {
        switch self {
        case "USD":
            return "$"
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        default:
            return self
        }
    }
}

