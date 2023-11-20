//
//  CountryManagerTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

class CountryManagerTests: XCTestCase {
    var sut: CountryManager!
    let countryKey = "selectedEbayCountry"
    
    override func setUp() {
        super.setUp()
        sut = CountryManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        // Cleanup: remove the stored country after each test
        UserDefaults.standard.removeObject(forKey: countryKey)
    }
    
    func testSaveCountryChoice_SavesToUserDefaults() {
        // Given
        let country = EbayCountry.US
        
        // When
        sut.saveCountryChoice(country)
        
        // Then
        let savedCountryRawValue = UserDefaults.standard.string(forKey: countryKey)
        XCTAssertEqual(savedCountryRawValue, country.rawValue)
    }
    
    func testGetSavedCountryChoice_RetrievesFromUserDefaults() {
        // Given
        let country = EbayCountry.CH
        UserDefaults.standard.set(country.rawValue, forKey: countryKey)
        
        // When
        let retrievedCountry = sut.getSavedCountryChoice()
        
        // Then
        XCTAssertEqual(retrievedCountry, country)
    }
    
    func testGetSavedCountryChoice_ReturnsNil_WhenNoCountryIsSaved() {
        // Given: No country saved in UserDefaults
        
        // When
        let retrievedCountry = sut.getSavedCountryChoice()
        
        // Then
        XCTAssertNil(retrievedCountry)
    }
    
    func testGetSavedCountryChoice_ReturnsNil_WhenInvalidCountryRawValueIsSaved() {
        // Given
        let invalidCountryRawValue = "INVALID_COUNTRY"
        UserDefaults.standard.set(invalidCountryRawValue, forKey: countryKey)
        
        // When
        let retrievedCountry = sut.getSavedCountryChoice()
        
        // Then
        XCTAssertNil(retrievedCountry)
    }
}

