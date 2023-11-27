//
//  ImageServiceTests.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 07/11/2023.
//

import XCTest
@testable import ValuCards

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
        guard let testImage = UIImage(named: "testImage", in: Bundle(for: type(of: self)), compatibleWith: nil) else {
            XCTFail("Failed to load the test image.")
            return
        }
        mockImageProvider.imageData = testImage.pngData()

        XCTAssertNotNil(mockImageProvider.imageData, "Mock image data should not be nil")

        let expectation = self.expectation(description: "Image should be downloaded successfully")

        sut.downloadImage(from: "https://example.com/image.png") { image in
            XCTAssertEqual(image?.pngData(), testImage.pngData())
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }


    func testFailedImageDownload() {
        mockImageProvider.shouldFail = true

        let expectation = self.expectation(description: "Image download should fail")

        sut.downloadImage(from: "https://example.com/image.png") { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}
