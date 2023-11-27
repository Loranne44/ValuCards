//
//  ResponseModelTest.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 20/10/2023.
//

import XCTest
@testable import ValuCards

/// Tests for ResponseModel, handling the logic of displaying card images and titles.
final class ResponseModelTest: XCTestCase {
    
    /// Test to verify the functionality of showing the next image.
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
    
    /// Test to verify the functionality of showing the previous image.
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
    
    /// Test to verify retrieval of current image name.
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
    
    /// Test to verify retrieval of current title.
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
    
    /// Test to verify behavior with an empty list of card items.
    func testGetCurrentImageNameAndTitleWithEmptyList() {
        // Given
        let sut = ResponseModel(cardItems: [])
        
        // Then
        XCTAssertEqual(sut.getCurrentImageName(), "")
        XCTAssertEqual(sut.getCurrentTitle(), "")
    }
}
