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
    /// Initializes the model with a collection of card items
    init(cardItems: [CardItem]) {
        self.cardItems = cardItems
    }
    
    // MARK: - Image Navigation Methods
    /// Advances to the next image in the collection
    func showNextImage() {
        currentImageIndex = (currentImageIndex + 1) % cardItems.count
    }
    
    /// Goes back to the previous image in the collection
    func showPreviousImage() {
        currentImageIndex = (currentImageIndex - 1 + cardItems.count) % cardItems.count
    }
    
    /// Returns the name of the current image
    func getCurrentImageName() -> String {
        guard !cardItems.isEmpty else { return "" }
        return cardItems[currentImageIndex].imageName
    }
    
    /// Returns the title of the current image
    func getCurrentTitle() -> String {
        guard !cardItems.isEmpty else { return "" }
        return cardItems[currentImageIndex].title
    }
}
