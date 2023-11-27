//
//  PriceCategory.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation

// MARK: - Properties
class PriceCategory {
    var range: ClosedRange<Int> /// Represents a closed range of integers
    var label: String /// Label associated with the price range
    
// MARK: - Initialization
    /// Initializes a PriceCategory with a range and a label
    init(range: ClosedRange<Int>, label: String) {
        self.range = range
        self.label = label
    }
}
