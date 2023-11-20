//
//  StringExtensionTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

final class StringExtensionTests: XCTestCase {
    
    func testCurrencySymbol() {
        XCTAssertEqual("USD".currencySymbol(), "$")
        XCTAssertEqual("EUR".currencySymbol(), "€")
        XCTAssertEqual("GBP".currencySymbol(), "£")
        XCTAssertEqual("CHF".currencySymbol(), "CHF")
        XCTAssertEqual("JPY".currencySymbol(), "¥")
        XCTAssertEqual("CAD".currencySymbol(), "CA$")
        XCTAssertEqual("AUD".currencySymbol(), "A$")
        XCTAssertEqual("INVALID_CURRENCY".currencySymbol(), "INVALID_CURRENCY")
    }
}

