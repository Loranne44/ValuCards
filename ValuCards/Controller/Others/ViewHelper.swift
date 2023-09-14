//
//  ViewHelper.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 14/09/2023.
//

import Foundation
import UIKit

struct ViewHelper {
    
    // Constantes pour une meilleure gestion et une consistance
    private static let cornerRadius: CGFloat = 40
    private static let shadowOpacity: Float = 0.8
    private static let shadowRadius: CGFloat = 9.0
    private static let shadowOffset = CGSize(width: 0, height: 0)
    
    static func setupImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = shadowOffset
        imageView.layer.shadowOpacity = shadowOpacity
        imageView.layer.shadowRadius = shadowRadius
        imageView.isUserInteractionEnabled = true
        
        updateShadowForImageView(imageView: imageView)
    }

    static func updateShadowForImageView(imageView: UIImageView) {
        let shadowSize: CGFloat = 20.0
        let shadowPathTop = UIBezierPath(rect: CGRect(x: 0, y: -shadowSize, width: imageView.frame.width, height: shadowSize))
        let shadowPathBottom = UIBezierPath(rect: CGRect(x: 0, y: imageView.frame.height, width: imageView.frame.width, height: shadowSize))
        let combinedShadowPath = UIBezierPath()
        combinedShadowPath.append(shadowPathTop)
        combinedShadowPath.append(shadowPathBottom)
        
        imageView.layer.shadowPath = combinedShadowPath.cgPath
    }

    // Cette méthode configure l'ombre et les coins arrondis pour une vue donnée
    static func applyShadowAndRoundedCorners(to view: UIView, shadowPosition: ShadowPosition) {
        view.layer.cornerRadius = 10
        view.clipsToBounds = false
        
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
        shadowLayer.frame = view.bounds
        
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        switch shadowPosition {
        case .top:
            shadowLayer.shadowOffset = CGSize(width: 0, height: -4)
            path.addRect(CGRect(x: 0, y: 0, width: view.bounds.width, height: 10))
        case .both:
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            path.addRect(CGRect(x: 0, y: 0, width: view.bounds.width, height: 10))
            path.addRect(CGRect(x: 0, y: view.bounds.height - 10, width: view.bounds.width, height: 10))
        }
        
        maskLayer.path = path
        shadowLayer.mask = maskLayer
        
        view.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    enum ShadowPosition {
        case top
        case both
    }
}
