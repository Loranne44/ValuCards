//
//  IntValueFormatter.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import DGCharts

// MARK: - Value Formatting
class IntValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(Int(value))
    }
}
