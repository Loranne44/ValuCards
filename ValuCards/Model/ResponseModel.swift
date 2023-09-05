//
//  ResponseModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation

class ResponseModel {
    var cardItems: [CardItem]
    var currentImageIndex = 0
    
    init(cardItems: [CardItem]) {
        self.cardItems = cardItems
    }
    
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
    
    func getCurrentPrice() -> Price {
        guard !cardItems.isEmpty else { return Price(value: "", currency: "") }
        return cardItems[currentImageIndex].price
    }
}
