//
//  ImageService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import UIKit

// MARK: - ImageServiceProtocol
protocol ImageServiceProtocol {
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
}

// MARK: - ImageService
class ImageService: ImageServiceProtocol {
    private let session: URLSession
        private var imageProvider: ImageServiceProtocol?

        init(session: URLSession = URLSession.shared) {
            self.session = session
        }

        init(imageProvider: ImageServiceProtocol) {
            self.session = URLSession.shared
            self.imageProvider = imageProvider
        }

    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
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
