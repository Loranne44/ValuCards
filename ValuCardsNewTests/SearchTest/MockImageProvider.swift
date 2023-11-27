//
//  MockImageProvider.swift
//  ValuCardsNewTests
//
//  Created by Loranne Joncheray on 07/11/2023.
//
/*
import Foundation
import UIKit
@testable import ValuCards

/// Mock class for simulating image download service.
class MockImageProvider: ImageServiceProtocol {
    var imageData: Data?
    var shouldFail: Bool = false

    /// Mock implementation of image download method.
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if shouldFail {
            completion(nil)
        } else if let imageData = self.imageData {
            completion(UIImage(data: imageData))
        } else {
            completion(nil)
        }
    }
}
*/
