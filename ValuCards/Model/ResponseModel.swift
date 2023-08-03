//
//  ResponseModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation

class ResponseModel {
    var imageNames: [String]
    var currentImageIndex = 0
    
    init(imageUrls: [String]) {
        self.imageNames = imageUrls
    }
    
    func showNextImage() {
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
    }
    
    func showPreviousImage() {
        currentImageIndex = (currentImageIndex - 1 + imageNames.count) % imageNames.count
    }
    
    func getCurrentImageName() -> String {
        return imageNames[currentImageIndex]
    }
}
