//
//  ViewHelper.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 14/09/2023.
//

import Foundation
import UIKit

struct ViewHelper {
    
    // MARK: - Properties
    private static let cornerRadius: CGFloat = 40
    private static let shadowOpacity: Float = 0.8
    private static let shadowRadius: CGFloat = 9.0
    private static let shadowOffset = CGSize(width: 0, height: 0)
    
    // MARK: - Helper Functions
    static func applyShadowAndRoundedCorners(to view: UIView, shadowPosition: ShadowPosition) {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor(hex: "#7090B0").cgColor
        view.layer.shadowOffset = shadowOffset
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        
        switch shadowPosition {
        case .top:
            let shadowSize = 2.20
            let shadowPathTop = UIBezierPath(rect: CGRect(x: 5, y: -shadowSize, width: view.frame.width, height: shadowSize))
            view.layer.shadowPath = shadowPathTop.cgPath
        case .bottom:
            let shadowSize = 2.20
            let shadowPathBottom = UIBezierPath(rect: CGRect(x: 4, y: view.frame.height, width: view.frame.width, height: shadowSize))
            view.layer.shadowPath = shadowPathBottom.cgPath
        }
    }
    
    // MARK: - ShadowPosition Enumeration
    enum ShadowPosition {
        case top
        case bottom
    }
}


// A mettre dans un fichier extension
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
