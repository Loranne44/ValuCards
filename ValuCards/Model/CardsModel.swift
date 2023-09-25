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
    static let apiKey = "v^1.1#i^1#f^0#I^3#r^0#p^1#t^H4sIAAAAAAAAAOVYe2xTVRhfu42HA6aBgA6j5Q4hYd7b++jr3q2V7uVK9ii0jEIieHrv6XrX9t7Lvads1UjmSMgw8o8mM1EJQxN1QkxIAGMIJIIaUUOCMPExgUQFYyCBkEhMBD23LaObBJA1cYn9pznf+c53vt/ve5xzD903beayrS1br822TLcO9dF9VouFqaBnTiuvmVNqrSovoQsULEN9i/vK+kt/rTNAKqkJq6ChqYoBbb2ppGIIWaGXSOuKoAJDNgQFpKAhIFEI+dtaBZaiBU1XkSqqScIWaPQSURfP8jEYdUYZD+MADJYqN22GVS/BRTkPx4oOTuQ9MQhZPG8YaRhQDAQU5CVYmuVImidZZ5jmBadbcPAUR7PrCFsn1A1ZVbAKRRO+rLtCdq1e4OudXQWGAXWEjRC+gL851OEPNDa1h+vsBbZ8eR5CCKC0MX7UoErQ1gmSaXjnbYysthBKiyI0DMLuy+0w3qjgv+nMfbifpRpAyQE9HIAuh0MCorsoVDaregqgO/thSmSJjGVVBaggGWXuxihmI9oNRZQftWMTgUab+bcyDZJyTIa6l2iq96/1B4OEr1XVgaLAFaTJdgPQJTK4qpF08i6aZz1uB8kDJwQuxpHfKGctT/OEnRpURZJN0gxbu4rqIfYaTuTGUcANVupQOnR/DJkeFegxTJ5DlvesM4Oai2IaxRUzrjCFibBlh3ePwNhqhHQ5mkZwzMLEiSxFONaaJkvExMlsLubTp9fwEnGENMFu7+npoXo4StW77CxNM/ZIW2tIjMMUILCuWes5ffnuC0g5C0WEeKUhCyijYV96ca5iB5Quwudwe1jak+d9vFu+idJ/CAow28dXRLEqhPWIMY87RoswGmNiHF2MCvHlk9Ru+gGjIEOmgJ6ASEsCEZIizrN0CuqyJHDOGMvhHkdKLj5GOvhYjIw6JRfJ4LZHQxiN4g74fyqUe031EBR1iIqS60XL85aE3R/W5JWNzuZUCG1q1tKZTISXersjQAu45Ai/smbt6vZIfaS1zXuv1XBb8A1JGTMTxvsXgwCz1otIgmogKE0KXkhUNRhUk7KYmVoB5nQpCHSUCcFkEgsmBdKvaYHi9OqiwfuXbeL+cBfvjPqPzqfbojLMlJ1aqMz1BjYANJkyTyBKVFN2s9ZVgK8fpnhD1utJ4ZbxzXVKocYgc2hlKXflpLJwKWOTSOnQUNM6vm1THeYNLKwmoILPM6SrySTUO5lJ13MqlUYgmoRTrbCLkOAymGKHLePinS7O6XHxk8IlZo/SDVOtJRWjFZc9fZ/Xavv4j3xfSfbH9FuO0P2Ww1aLha6jn2Cq6UXTSleXlc6qMmQEKRnEKEPuUvC3qw6pBMxoQNatc0uu0RfeEC+2DL+UuNGz8XztCyWFbwxDz9APj70yzCxlKgqeHOhHb82UM5ULZrMcBu+keafbwa+jq2/NljHzy+Z5zu7488fLo6CjbY33+8NDz0cPbTtNzx5TsljKS8r6LSU1B/YNbo/X/NLy1fWzDeXnD5F9TbNO1gX2XKxfOn3gwmvfHN18dfGI0r5+X3CLfe6SZ+sOvlKxi7mxtPuzwcvLjpW8urHh6+4n39XZ+sSVvdr+A9/u7Xzzj8jjlzIr9r7Y9OFR67Knjl89WD2yJu4uty6KL/+rv6s+HFd2Db6z85xt8/L51gePhbfuD3wcHN1x4oPwI9ePDl/w79HYys8Xp9/+fXT0yqm609UPLTqV0N9ff9K27afHoldfHzh06fLCOakZVUztiJ96ecalgXOhYX5n7SdfLPjuh8HDx5fvmXcG1W6JV1Z++dzwR8PbVv92pKKx6q2Fu8O7B86FR5p//vS9mpFM2wPTz1Q5WtYvOZGL5d8bXnBX/REAAA=="
    
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
                    completion(.failure(.jsonDecodingError(error: error)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
