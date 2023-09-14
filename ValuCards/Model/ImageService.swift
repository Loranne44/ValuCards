//
//  ImageService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/09/2023.
//

import Foundation
import UIKit

/// Service to download images from given URLs.
class ImageService {
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

