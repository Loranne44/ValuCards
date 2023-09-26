//
//  PriceCategory.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation

// MARK: - Properties
class PriceCategory {
    var range: ClosedRange<Int>
    var label: String
    
// MARK: - Initialization
    init(range: ClosedRange<Int>, label: String) {
        self.range = range
        self.label = label
    }
}
