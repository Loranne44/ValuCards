//
//  IntValueFormatterTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
import DGCharts
@testable import ValuCards

final class IntValueFormatterTests: XCTestCase {
    
    var formatter: IntValueFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = IntValueFormatter()
    }
    
    override func tearDown() {
        formatter = nil
        super.tearDown()
    }
    
    func testStringForValue_ReturnsIntegerString() {
        let doubleValue: Double = 42.567
        let expectedString = "42"
        let resultString = formatter.stringForValue(doubleValue, entry: ChartDataEntry(x: 1, y: doubleValue), dataSetIndex: 0, viewPortHandler: nil)
        XCTAssertEqual(expectedString, resultString)
    }
}
