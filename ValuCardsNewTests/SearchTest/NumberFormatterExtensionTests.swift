//
//  NumberFormatterExtensionTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

/// Tests for extensions on NumberFormatter.
final class NumberFormatterExtensionTests: XCTestCase {
    
    /// Test to verify formatting of non-null double values into a currency string.
    func testFormatPrice_WithNonNullValue() {
        let price: Double? = 123.4567
        let expectedString = "123.46"
        let resultString = NumberFormatter.formatPrice(price)
        XCTAssertEqual(expectedString, resultString)
    }
    
    /// Test to verify behavior when formatting a nil double value.
    func testFormatPrice_WithNilValue() {
        let price: Double? = nil
        let expectedString = "NB"
        let resultString = NumberFormatter.formatPrice(price)
        XCTAssertEqual(expectedString, resultString)
    }
}

