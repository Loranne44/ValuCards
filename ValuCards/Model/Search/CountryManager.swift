//
//  CountryManager.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation

class CountryManager {
    static let shared = CountryManager()
    
    private let userDefaults = UserDefaults.standard /// UserDefaults for storing data
    private let countryKey = "selectedEbayCountry" /// Key for saving country selection
    
    /// Saves the user's country choice
    func saveCountryChoice(_ country: EbayCountry) {
        userDefaults.set(country.rawValue, forKey: countryKey)
    }
    
    /// Retrieves the saved country choice
    func getSavedCountryChoice() -> EbayCountry? {
        if let savedCountryRawValue = userDefaults.string(forKey: countryKey),
           let savedCountry = EbayCountry(rawValue: savedCountryRawValue) {
            return savedCountry
        }
        return nil
    }
}
