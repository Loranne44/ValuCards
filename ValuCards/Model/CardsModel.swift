//
//  ValuCardsService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation
import Alamofire

class CardsModel {
    // MARK: - Singleton pattern
    // Provides a single shared instance of CardsModel throughout the application
    static let shared = CardsModel()
    
    // MARK: - Properties
    private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    // The eBay API key
    static let apiKey = "v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYb2wTZRhv1w5CxgYiwYlEy4GJYfT6Xntt7861ptsY6xzboGMOVObbu7fj6PXuvHvLVv5lTNwHkOiIoAE/TNAE4xCDX/xDQAjGDxr5IxHiB4mASuKISQeiaIx3bRndJICsiUvsl+ae93mf9/f7Pc/zvu8d6J4waV5vXe+1UuvEov5u0F1ktVIlYNKE4ooyW9HMYgvIc7D2d8/ttvfYLlXqMCGp3BKkq4qsI0dXQpJ1LmMMEElN5hSoizonwwTSOcxzkdCiBs5NAk7VFKzwikQ4wjUBgmV5DwACS0EGIDYWM6zyjZgtSoBA3hjFu2kP6xfcvij0G+O6nkRhWcdQxgHCDdweJ2CdFN1CuTmK5jwM6WeZ5YSjFWm6qMiGCwmIYAYul5mr5WG9PVSo60jDRhAiGA7VRppC4ZoFjS2VrrxYwZwOEQxxUh/5VK0IyNEKpSS6/TJ6xpuLJHke6TrhCmZXGBmUC90Acw/wM1JDSmB8PoqBwCN4Ec8WRMpaRUtAfHscpkUUnLGMK4dkLOLUnRQ11IiuQjzOPTUaIcI1DvNvcRJKYkxEWoBYUBVaFmpuJoINigZlGdU7TbWroSY4m5fUOL2sD7Buxk87WehF0EfRuYWy0XIyj1qpWpEF0RRNdzQquAoZqNFobUCeNoZTk9ykhWLYRJTvRw9rSC83k5rNYhKvlM28ooQhhCPzeOcMDM/GWBOjSYyGI4weyEhk5FpVRYEYPZipxVz5dOkBYiXGKudydXZ2kp0eUtE6XG4AKFfbooYIvxIlIGH4mr2e9RfvPMEpZqjwyJipixxOqQaWLqNWDQByBxGk/YwbMDndR8IKjrb+w5DH2TWyIwrVITSICh4I/QxkGF/UhwrRIcFckbpMHCgKU84E1OIIqxLkkZM36iyZQJoocB5vzO1hYsgp+NiYkzb2QmfUK/icVAwhgFA0yrPM/6lR7rbUI4jXEC5IrReszuvirlCLKi6u8dYmInh1rZpMpdpYoWtVG1TDPrGNXVyxbGljW1Vbw6LA3XbDLclXS6KhTIuxfiEEMHu9gCIoOkbCmOhFeEVFzYok8qnxlWCPJjRDDaciSJIMw5hIhlQ1XJi9umD0/uU2cW+8C3dG/Ufn0y1Z6WbJji9W5nzdCABVkTRPIJJXEi6z1xVoXD9Mc3sG9Zh4i8bNdVyxNkhm2YpC9spJZuiS+mqe1JCuJDXjtk02mTewFiWOZOM8w5oiSUhrpcbcz4lEEsOohMZbYxegwEU4zg5bysfSPtbj84+NF585StvH25ZUiK3YvvAer9WukS/5QUvmR/VYj4Ie66EiqxVUgkepOWD2BNtSu23yTF3EiBRhjNTFDtl4d9UQGUcpFYpa0f2Wa+CnXfxg3Tub4391Pv/j4+st+d8Y+p8F5cNfGSbZqJK8Tw5g1s2RYmrKA6VuD2ApmnJTtIdZDubcHLVTM+zTp3XsL3mpTK3alijzTN99btqpMz8fAqXDTlZrscXeY7XU75SmfdWnTnn1zwPp9ODWwfQ8sb381/Khqx+vC79WGQ6VHntzR+vnJ488tK1k22/17JWD34Uu4+3R169GYzsrTrXPfuvC5XhlcOA5Yc+By0dWVJZvmUW+sKJ669564slv6BL6WO8g9+LFyQcvfH9xcMNaHzP0w8Dbel/o5ejG3rMnQvT89Nr59/1StiEyMGMTt+fSu9bt6870r+hKR23nahjb+UdmXPEPPfPE+afx1489bNslXJy4a+9n7eV9U9enP1i47uzWgb74+1NPrzn6yeFv7ZuKTn9xWFqzb/PmB19BQxt37L/w3oc7T8ytSKtM9+G60yfL4PGNVz7ad9zxlPfsHxXXv3xj9/VPf9+bTaXlb/HLn1n9EQAA"
    
    // API headers containing the authorization
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // Initialize with a default or provided session
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    // MARK: - SearchCards method
    // Searches for cards based on name and country, then triggers the completion handler with the results
    func searchCards(withName name: String, inCountry country: EbayCountry, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        
        // Convert spaces in the name to '+' for URL encoding
        let searchQuery = name.split(separator: " ").joined(separator: "+")
        
        // Construct the URL components
        var components = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
        components?.queryItems = [
            URLQueryItem(name: "q", value: searchQuery),
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "category_ids", value: "2536")
        ]
        
        // Add headers specific to the search query
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CardsModel.apiKey)",
            "X-EBAY-C-MARKETPLACE-ID": country.rawValue
        ]
        
        // Ensure the URL is valid
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        // Cancel the previous task if it exists
        task?.cancel()
        session.getRequest(url: url, headers: headers) { result in
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
                    
                    // Check if the response is empty and return appropriate results
                    if responseJSON.itemSummaries.isEmpty {
                        completion(.failure(.noCardsFound))
                    } else {
                        completion(.success(responseJSON))
                    }
                    
                } catch {
                    // Handle JSON decoding errors
                    completion(.failure(.jsonDecodingError(error: error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
// Google Goggle
// Plutot passer par des webService type Google Lens ? Chat Gpt 4 ? Que CoreML

// Nettoyer l'image comme note; mise a plat d'image
