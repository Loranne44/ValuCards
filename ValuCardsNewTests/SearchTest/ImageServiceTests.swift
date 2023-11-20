//
//  ImageServiceTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 07/11/2023.
//

import XCTest
@testable import ValuCards
/*
class ImageServiceTests: XCTestCase {
    var sut: ImageService!
    var mockImageProvider: MockImageProvider!

    override func setUpWithError() throws {
        super.setUp()
        mockImageProvider = MockImageProvider()
        sut = ImageService(imageProvider: mockImageProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockImageProvider = nil
        super.tearDown()
    }

    func testSuccessfulImageDownload() {
        // Assurez-vous que testImage.png est ajoutée aux ressources du bundle de test.
        guard let testImage = UIImage(named: "testImage", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Failed to load the test image.")
            return
        }
        mockImageProvider.imageData = testImage.pngData()

        let expectation = self.expectation(description: "Image should be downloaded successfully")

        sut.downloadImage(from: "https://example.com/image.png") { image in
            XCTAssertEqual(image?.pngData(), testImage.pngData())
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testFailedImageDownload() {
        // Simuler un échec de téléchargement d'image
        mockImageProvider.error = NSError(domain: "network", code: 404, userInfo: nil)

        let expectation = self.expectation(description: "Image download should fail")

        sut.downloadImage(from: "https://example.com/image.png") { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
*/
