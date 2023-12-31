//
//  IntValueFormatter.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import DGCharts

// MARK: - Value Formatting
/// Formatter for converting chart values to integer string representation
class IntValueFormatter: ValueFormatter {
    /// Formats a double value as an integer string
    func stringForValue(_ value: Double,
                        entry _: ChartDataEntry,
                        dataSetIndex _: Int,
                        viewPortHandler _: ViewPortHandler?) -> String {
        return String(Int(value))
    }
}
