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
    static let apiKey = "v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYa4wTVRTe2W3BFRB5CAQEyiwPYZ12Xu12hm2x291mq/ukZbMgitPpnWXY6cw495bdJjyWjWyUGAM+8IckIiEBDIprRNQ1PvCPEiKKf8CQgMaAxA2JykNRxJm2LN2VALJNbGL/NPfcc8/9vu+ec++dS3aNKF3QU9tzaQw2snh7F9lVjGHUKLJ0hL38npLiqfYiMscB2941u8vWXfJjJRQSis4vBlDXVAgcnQlFhXza6MOThsprApQhrwoJAHkk8pFAfR1PO0leNzSkiZqCO8LVPlyQWMHLuWM0zQDaWyGZVvVazKjmw2MsV+FmKZKJszG3l/WY/RAmQViFSFCRD6dJmiFIjqCpKEXxLMuTnJPj3MtwRwswoKyppouTxP1puHx6rJGD9eZQBQiBgcwguD8cCEUaA+HqmoZopSsnlj+rQwQJKAkHt4JaHDhaBCUJbj4NTHvzkaQoAghxlz8zw+CgfOAamDuAn5a6QhKZCg8liqyXBgzw5kXKkGYkBHRzHJZFjhNS2pUHKpJR6laKmmrEVgERZVsNZohwtcP6a04KiizJwPDhNVWBpYGmJtxfpxmCqoKHCUvtoGDEiabF1YSb85CcmVQswQluIHgoNjtRJlpW5iEzBTU1LluiQUeDhqqAiRoM1YbJ0cZ0alQbjYCELES5fsyAhtQya1Ezq5hEK1VrXUHCFMKRbt56BQZGI2TIsSQCAxGGdqQlMstK1+U4PrQznYvZ9OmEPnwlQjrvcnV0dDg7GKdmtLlokqRcrfV1EXElSAi46WvVesZfvvUAQk5TEYE5Eso8Sukmlk4zV00AahvuZyu8NOnN6j4Yln+o9R+GHM6uwRWRrwoRPWKMEmIiw3hoycvko0D82Rx1WTBATEgRCcFoB0hXBBEQoplmyQQw5DjPuCWa8UqAiHs4iWA5SSJi7riHoCQASABiMZHz/p/q5HYzPQJEA6C8pHre0ry23RWI6nJztTuUiKDVIT2ZSrVy8c5VrYIe9sitXHP50iUNrVWtdfW+2y2GG5IPKrKpTNScv/BqvVaDCMSHRS8iajpo0hRZTBXWAjNGvEkwUCoCFMU0DItkQNfD+dmq80bvX24Td8Y7f0fUf3Q83ZAVtFK2sFhZ46EZQNBlp3UCOUUt4dKsWhfM24dlXpFGPSzesnlxLSjWJskMWzmeuXE6NYuuE64WnQaAWtIwL9vORusCFtXagWqeZ8jQFAUYLdSw6zmRSCIhpoBCK+w8JLgsFNhhS3k4N815PCw3LF5i+ihdUWhbUl62Ylvozm7VrsHf+P6i9I/qxg6S3dhHxRhGVpJzqDJy1oiSJbaS0VOhjIBTFiQnlNtU89PVAM52kNIF2SieUHSJPPOK2F+7Z1P7Xx1Pnl64tij3iWH7Y+SUgUeG0hJqVM6LA3n/9R47NXbyGJoxyVMUxbIkt4wsu95roybZJuI/LDzJz2urefehB1Lnez+998T598+QYwacMMxeZOvGitjjW2eIa4pnrv+i+fSsS9ixb09V/XIZ+3z22vf2Px3of6a258HIztjovvn2Jdhdhw/sWtp75GJw7vT7tJ+btK+/2rF30b7NH3+mSZfLZ+zo//DCy1P3245eWBfbd6wGvLPxe/zPzfYpHxzd2RC9GuyDW66gYwt6fBOvlq83et9+/fc5L14YFzx3KHT87IZVb02ev+nsq6fs8177pr7l0U01+FWGCFSOLBv3xrY3p8Fnp+8uvnvtJ1j1xecOerbsPNmHldmfLx1/4LBj3bq9mye+5Fju/3WKY9yVIyXjJ/gfP7hrpmdR79zOPYe+PAH+mDb6SB9YsXVb75pt3z0V2j3pheWPjP3piQ2/dZ+zz1T622FmLf8G4Ht7A/wRAAA="
    
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
