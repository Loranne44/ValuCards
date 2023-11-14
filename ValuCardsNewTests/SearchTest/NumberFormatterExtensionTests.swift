//
//  NumberFormatterExtensionTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

final class NumberFormatterExtensionTests: XCTestCase {
    
    func testFormatPrice_WithNonNullValue() {
        let price: Double? = 123.4567
        let expectedString = "123.46"
        let resultString = NumberFormatter.formatPrice(price)
        XCTAssertEqual(expectedString, resultString)
    }
    
    func testFormatPrice_WithNilValue() {
        let price: Double? = nil
        let expectedString = "NB"
        let resultString = NumberFormatter.formatPrice(price)
        XCTAssertEqual(expectedString, resultString)
    }
}
