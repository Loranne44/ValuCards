//
//  ResponseModelTest.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards
/*
final class ResponseModelTest: XCTestCase {
    
    func testShowNextImage() {
        // Given
        let cardItems = [CardItem(imageName: "image1", title: "Title1"),
                         CardItem(imageName: "image2", title: "Title2")]
        let sut = ResponseModel(cardItems: cardItems)
        
        // When
        sut.showNextImage()
        
        // Then
        XCTAssertEqual(sut.currentImageIndex, 1)
    }
    
    func testShowPreviousImage() {
        // Given
        let cardItems = [CardItem(imageName: "image1", title: "Title1"),
                         CardItem(imageName: "image2", title: "Title2")]
        let sut = ResponseModel(cardItems: cardItems)
        sut.showNextImage()
        
        // When
        sut.showPreviousImage()
        
        // Then
        XCTAssertEqual(sut.currentImageIndex, 0)
    }
    
    func testGetCurrentImageName() {
        // Given
        let cardItems = [CardItem(imageName: "image1", title: "Title1"),
                         CardItem(imageName: "image2", title: "Title2")]
        let sut = ResponseModel(cardItems: cardItems)
        
        // Then
        XCTAssertEqual(sut.getCurrentImageName(), "image1")
        
        // When
        sut.showNextImage()
        
        // Then
        XCTAssertEqual(sut.getCurrentImageName(), "image2")
    }
    
    func testGetCurrentTitle() {
        // Given
        let cardItems = [CardItem(imageName: "image1", title: "Title1"),
                         CardItem(imageName: "image2", title: "Title2")]
        let sut = ResponseModel(cardItems: cardItems)
        
        // Then
        XCTAssertEqual(sut.getCurrentTitle(), "Title1")
        
        // When
        sut.showNextImage()
        
        // Then
        XCTAssertEqual(sut.getCurrentTitle(), "Title2")
    }
    
    func testGetCurrentImageNameAndTitleWithEmptyList() {
        // Given
        let sut = ResponseModel(cardItems: [])
        
        // Then
        XCTAssertEqual(sut.getCurrentImageName(), "")
        XCTAssertEqual(sut.getCurrentTitle(), "")
    }
}
*/