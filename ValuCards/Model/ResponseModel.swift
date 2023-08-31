//
//  ResponseModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation

class ResponseModel {
    var imagesAndTitlesAndPrices: [(imageName: String, title: String, price: Price)]

    var currentImageIndex = 0
    
    init(imagesAndTitlesAndPrices: [(imageName: String, title: String, price: Price)]) {
        self.imagesAndTitlesAndPrices = imagesAndTitlesAndPrices
    }

    
    func showNextImage() {
        currentImageIndex = (currentImageIndex + 1) % imagesAndTitlesAndPrices.count
    }
    
    func showPreviousImage() {
        currentImageIndex = (currentImageIndex - 1 + imagesAndTitlesAndPrices.count) % imagesAndTitlesAndPrices.count
    }
    
    func getCurrentImageName() -> String {
        return imagesAndTitlesAndPrices[currentImageIndex].imageName
    }
    
    func getCurrentTitle() -> String {
        return imagesAndTitlesAndPrices[currentImageIndex].title
    }
    
    func getCurrentPrice() -> Price {
        return imagesAndTitlesAndPrices[currentImageIndex].price
    }
}
