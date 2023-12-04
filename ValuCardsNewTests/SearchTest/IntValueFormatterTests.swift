//
//  IntValueFormatterTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
import DGCharts
@testable import ValuCards

/// Tests for IntValueFormatter used in chart data formatting.
final class IntValueFormatterTests: XCTestCase {
    
    var formatter: IntValueFormatter!
    
    /// Setup method to initialize the formatter.
    override func setUp() {
        super.setUp()
        formatter = IntValueFormatter()
    }
    
    /// Teardown method to clean up after tests.
    override func tearDown() {
        formatter = nil
        super.tearDown()
    }
    
    /// Test to ensure correct string representation of integer values from double.
    func testStringForValue_ReturnsIntegerString() {
        let doubleValue: Double = 42.567
        let expectedString = "42"
        let resultString = formatter.stringForValue(doubleValue, entry: ChartDataEntry(x: 1, y: doubleValue), dataSetIndex: 0, viewPortHandler: nil)
        XCTAssertEqual(expectedString, resultString)
    }
}
