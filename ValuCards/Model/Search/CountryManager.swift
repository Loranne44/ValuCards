//
//  CountryManager.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation

class CountryManager {
    static let shared = CountryManager()
    
    private let userDefaults = UserDefaults.standard
    private let countryKey = "selectedEbayCountry"
    
    func saveCountryChoice(_ country: EbayCountry) {
        userDefaults.set(country.rawValue, forKey: countryKey)
    }
    
    func getSavedCountryChoice() -> EbayCountry? {
        if let savedCountryRawValue = userDefaults.string(forKey: countryKey),
           let savedCountry = EbayCountry(rawValue: savedCountryRawValue) {
            return savedCountry
        }
        return nil
    }
}
