//
//  CardGestureHandler.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import UIKit

class CardGestureHandler {
    private let maxRotationAngle: CGFloat = CGFloat.pi / 3
    
    /// Returns a transform (translation + rotation) based on the user's gesture translation.
    func getTransformForTranslation(_ translation: CGPoint) -> CGAffineTransform {
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationPercent = translation.x / (UIScreen.main.bounds.width / 2)
        let rotationAngle = maxRotationAngle * translationPercent
        return translationTransform.concatenating(CGAffineTransform(rotationAngle: rotationAngle))
    }
    
    /// Returns an alpha value (opacity) based on the user's gesture translation.
    func getAlphaForTranslation(_ translation: CGPoint) -> CGFloat {
        let translationPercent = translation.x / (UIScreen.main.bounds.width / 2)
        return 1.0 - min(abs(translationPercent) * 2, 1.0)
    }
}
