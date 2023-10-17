//
//  EbayCountry.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation

enum EbayCountry: String, CaseIterable {
    // MARK: - Country Codes
    case US = "EBAY_US"
    case CH = "EBAY_CH"
    case GB = "EBAY_GB"
    case DE = "EBAY_DE"
    case JP = "EBAY_JP"
    case CA = "EBAY_CA"
    case FR = "EBAY_FR"
    case AU = "EBAY_AU"
    case ES = "EBAY_ES"
    
    // MARK: - Display Names
    var displayName: String {
        switch self {
        case .US: return "United States"
        case .CH: return "Switzerland"
        case .GB: return "United Kingdom"
        case .DE: return "Germany"
        case .JP: return "Japan"
        case .CA: return "Canada"
        case .FR: return "France"
        case .AU: return "Australia"
        case .ES: return "Spain"
        }
    }
}
