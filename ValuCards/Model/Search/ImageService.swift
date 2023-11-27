//
//  ImageService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import UIKit

// MARK: - ImageServiceProtocol
/// Protocol defining image download functionality
protocol ImageServiceProtocol {
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

// MARK: - ImageService
/// Service for downloading images
class ImageService: ImageServiceProtocol {
    
    private let session: URLSession
    private var imageProvider: ImageServiceProtocol?

    // Initializer for production use, using URLSession
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // Initializer for testing, using a mock image provider
    init(imageProvider: ImageServiceProtocol) {
        self.session = URLSession.shared
        self.imageProvider = imageProvider
    }

    /// Downloads an image from the specified URL string
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Use the imageProvider if available, for instance when testing
        if let imageProvider = self.imageProvider {
            imageProvider.downloadImage(from: urlString, completion: completion)
            return
        }

        // If no imageProvider is available, use URLSession to download the image
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }

        session.dataTask(with: imageUrl) { data, response, error in
            guard error == nil, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(nil)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
