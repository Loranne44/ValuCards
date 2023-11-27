//
//  ColorFilterService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import UIKit

// MARK: - ColorFilterService
/// Initializes UIColor from a hexadecimal string
class ColorFilterService {
    func filterColorForTranslation(_ translation: CGPoint) -> UIColor {
        return translation.x > 0 ? UIColor.green.withAlphaComponent(0.5) : UIColor.red.withAlphaComponent(0.5)
    }
}
