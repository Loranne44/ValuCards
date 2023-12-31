//
//  CardPricingServiceTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

/// Test suite for CardPricingService functionalities.
class CardPricingServiceTests: XCTestCase {
    
    var sut: CardPricingService!
    
    override func setUp() {
        super.setUp()
        sut = CardPricingService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /// Test to ensure average price calculation is correct.
    func testGetAveragePrice() {
        // Given
        let cards = [
            ItemSummary(itemId: "1", title: "Card1", leafCategoryIds: [], categories: [], price: Price(value: "10.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "2", title: "Card2", leafCategoryIds: [], categories: [], price: Price(value: "20.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "3", title: "Card3", leafCategoryIds: [], categories: [], price: Price(value: "30.0", currency: "USD"), thumbnailImages: nil)
        ]
        
        // When
        let average = sut.getAveragePrice(from: cards)
        
        // Then
        XCTAssertEqual(average, 20.0)
    }
    
    /// Test to verify correct identification of lowest price.
    func testGetLowestPrice() {
        // Given
        let cards = [
            ItemSummary(itemId: "1", title: "Card1", leafCategoryIds: [], categories: [], price: Price(value: "10.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "2", title: "Card2", leafCategoryIds: [], categories: [], price: Price(value: "20.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "3", title: "Card3", leafCategoryIds: [], categories: [], price: Price(value: "30.0", currency: "USD"), thumbnailImages: nil)
        ]
        
        // When
        let lowest = sut.getLowestPrice(from: cards)
        
        // Then
        XCTAssertEqual(lowest, 10.0)
    }
    
    /// Test to ensure highest price identification is correct.
    func testGetHighestPrice() {
        // Given
        let cards = [
            ItemSummary(itemId: "1", title: "Card1", leafCategoryIds: [], categories: [], price: Price(value: "10.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "2", title: "Card2", leafCategoryIds: [], categories: [], price: Price(value: "20.0", currency: "USD"), thumbnailImages: nil),
            ItemSummary(itemId: "3", title: "Card3", leafCategoryIds: [], categories: [], price: Price(value: "30.0", currency: "USD"), thumbnailImages: nil)
        ]
        
        // When
        let highest = sut.getHighestPrice(from: cards)
        
        // Then
        XCTAssertEqual(highest, 30.0)
    }
    
    /// Test to check handling of empty card array in price calculations.
    func testPricesWithEmptyArray() {
        // Given
        let cards: [ItemSummary] = []
        
        // When
        let average = sut.getAveragePrice(from: cards)
        let lowest = sut.getLowestPrice(from: cards)
        let highest = sut.getHighestPrice(from: cards)
        
        // Then
        XCTAssertEqual(average, 0.0)
        XCTAssertEqual(lowest, 0.0)
        XCTAssertEqual(highest, 0.0)
    }
}
