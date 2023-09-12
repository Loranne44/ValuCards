//
//  PriceCategory.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation

/// Represents a price category with a defined range and a label.
class PriceCategory {
    var range: ClosedRange<Int>
    var label: String

    init(range: ClosedRange<Int>, label: String) {
        self.range = range
        self.label = label
    }
}
