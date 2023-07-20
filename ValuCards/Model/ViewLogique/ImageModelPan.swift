//
//  ImageModelPan.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 20/07/2023.
//

import Foundation

struct CardModel {
    let imageNames = ["AA", "BB", "CC"]
    var currentImageIndex = 0
    
    mutating func showNextImage() {
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
    }
    
    mutating func showPreviousImage() {
        currentImageIndex = (currentImageIndex - 1 + imageNames.count) % imageNames.count
    }
    
    func getCurrentImageName() -> String {
        return imageNames[currentImageIndex]
    }
}
