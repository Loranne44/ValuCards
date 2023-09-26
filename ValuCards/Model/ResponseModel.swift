//
//  ResponseModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation

/// Model to manage and represent a collection of card items.
class ResponseModel {
    // MARK: - Properties
    var cardItems: [CardItem]
    var currentImageIndex = 0
    
    // MARK: - Initialization
    init(cardItems: [CardItem]) {
        self.cardItems = cardItems
    }
    
    // MARK: - Image Navigation Methods
    func showNextImage() {
        currentImageIndex = (currentImageIndex + 1) % cardItems.count
    }
    
    func showPreviousImage() {
        currentImageIndex = (currentImageIndex - 1 + cardItems.count) % cardItems.count
    }
    
    func getCurrentImageName() -> String {
        guard !cardItems.isEmpty else { return "" }
        return cardItems[currentImageIndex].imageName
    }
    
    func getCurrentTitle() -> String {
        guard !cardItems.isEmpty else { return "" }
        return cardItems[currentImageIndex].title
    }
}
