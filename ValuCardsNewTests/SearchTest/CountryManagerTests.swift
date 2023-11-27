//
//  CountryManagerTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

/// Test suite for CountryManager functionalities.
class CountryManagerTests: XCTestCase {
    var sut: CountryManager!
    let countryKey = "selectedEbayCountry"
    
    override func setUp() {
        super.setUp()
        sut = CountryManager.shared
    }
    
    /// Teardown method for clean-up after tests.
    override func tearDown() {
        super.tearDown()
        // Cleanup: remove the stored country after each test
        UserDefaults.standard.removeObject(forKey: countryKey)
    }
    
    /// Test to verify correct saving of country choice in UserDefaults.
    func testSaveCountryChoice_SavesToUserDefaults() {
        // Given
        let country = EbayCountry.US
        
        // When
        sut.saveCountryChoice(country)
        
        // Then
        let savedCountryRawValue = UserDefaults.standard.string(forKey: countryKey)
        XCTAssertEqual(savedCountryRawValue, country.rawValue)
    }
    
    /// Test to ensure correct retrieval of saved country choice from UserDefaults.
    func testGetSavedCountryChoice_RetrievesFromUserDefaults() {
        // Given
        let country = EbayCountry.CH
        UserDefaults.standard.set(country.rawValue, forKey: countryKey)
        
        // When
        let retrievedCountry = sut.getSavedCountryChoice()
        
        // Then
        XCTAssertEqual(retrievedCountry, country)
    }
    
    /// Test to handle scenario where no country choice is saved.
    func testGetSavedCountryChoice_ReturnsNil_WhenNoCountryIsSaved() {
        // Given: No country saved in UserDefaults
        
        // When
        let retrievedCountry = sut.getSavedCountryChoice()
        
        // Then
        XCTAssertNil(retrievedCountry)
    }
    
    /// Test to handle invalid country value saved in UserDefaults.
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
