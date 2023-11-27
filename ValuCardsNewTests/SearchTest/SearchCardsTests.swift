//
//  ValuCardsNewTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 16/10/2023.
//
/*
import XCTest
@testable import ValuCards

/// Test suite for search functionality in CardsModel.
class SearchCardsTests: XCTestCase {
    var sut: CardsModel!
    var mockProvider: MockCardsProvider!
    
    /// Setup method to initialize test environment.
    override func setUp() {
        super.setUp()
        mockProvider = MockCardsProvider()
        sut = CardsModel(session: mockProvider)
    }
    
    // Test to ensure successful card search.
    func testSearchCardsSuccess() {
        // Given
        let jsonString = """
        {
            "href": "http://test.com",
            "total": 1,
            "limit": 10,
            "offset": 0,
            "itemSummaries": [
                {
                    "itemId": "123",
                    "title": "TestCard",
                    "leafCategoryIds": ["1", "2"],
                    "categories": [
                        {
                            "categoryId": "1",
                            "categoryName": "TestCategory"
                        }
                    ],
                    "price": {
                        "value": "10.0",
                        "currency": "USD"
                    },
                    "thumbnailImages": [
                        {
                            "imageUrl": "http://test-image.com"
                        }
                    ]
                }
            ]
        }
        """
        let mockData = Data(jsonString.utf8)
        mockProvider.data = mockData
        
        let expectation = self.expectation(description: "Search cards should succeed")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "TestCard", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNotNil(searchResult, "Expected valid search result.")
        XCTAssertNil(searchError, "Expected no error.")
    }
    
    // Test to handle failure scenario in card search.
    func testSearchCardsFailure() {
        // Given
        mockProvider.error = .requestFailed
        
        let expectation = self.expectation(description: "Search cards should fail")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "TestCard", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.requestFailed)
    }
    
    /// Test to check behavior with invalid JSON data.
    func testSearchCardsJSONDecodingError() {
        // Given
        let invalidJsonString = """
            {
                "invalidKey": "This JSON doesn't match our model"
            }
            """
        let mockData = Data(invalidJsonString.utf8)
        mockProvider.data = mockData
        
        let expectation = self.expectation(description: "Search cards should return JSON decoding error")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "TestCard", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.jsonDecodingError)
    }
    
    /// Test to verify behavior with invalid URL error.
    func testSearchCardsInvalidURL() {
        // Given
        mockProvider.error = .invalidURL
        
        let expectation = self.expectation(description: "Search cards should return invalid URL error")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "TestCard", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.invalidURL)
    }
    
    /// Test to ensure handling of no matching cards scenario.
    func testSearchCardsNoMatchingCards() {
        // Given
        let emptyJsonString = """
            {
                "href": "http://test.com",
                "total": 0,
                "limit": 10,
                "offset": 0,
                "itemSummaries": []
            }
            """
        let mockData = Data(emptyJsonString.utf8)
        mockProvider.data = mockData
        
        let expectation = self.expectation(description: "Search cards should return no cards")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "InvalidCardName", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.noCardsFound, "Expected noCardsFound error.")
    }
    
    /// Test to verify behavior with empty search query.
    func testSearchCardsWithEmptyName() {
        // Given
        let expectation = self.expectation(description: "Search cards should return card name missing error")
        
        mockProvider.error = .cardNameMissing
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.cardNameMissing)
    }
    
    /// Test to handle server error scenarios.
    func testSearchCardsServerError() {
        // Given
        mockProvider.error = .serverError
        
        let expectation = self.expectation(description: "Search cards should return server error")
        
        // When
        var searchResult: ItemSearchResult?
        var searchError: ErrorCase?
        sut.searchCards(withName: "TestCard", inCountry: .US) { result in
            switch result {
            case .success(let items):
                searchResult = items
            case .failure(let error):
                searchError = error
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
        // Then
        XCTAssertNil(searchResult, "Expected no search result.")
        XCTAssertEqual(searchError, ErrorCase.serverError)
    }
}
*/
