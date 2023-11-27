//
//  ValuCardsService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation
import Alamofire
import FirebasePerformance

class CardsModel {
    // MARK: - Singleton pattern
    static let shared = CardsModel()
    
    // MARK: - Properties
    private let session : CardsProviderProtocol
    
    // MARK: - API Key & Headers
    static let apiKey = "2v^1.1#i^1#p^1#I^3#r^0#f^0#t^H4sIAAAAAAAAAOVYf2wTVRxvt26KMIwBnSEQ6k0SHN717npd23OtdBtlxbFutCxlE/H17h3cdr077l3ZiqLLCMiPGAIBNEIi+o+/Mo0GBf4QcJlMEZQQTIiREIzCVEIi8Qcgi961ZXSTALImNrH/NO/7vu/7vp/P9/t973uP7C4dV7m2fu0fZda7inZ1k91FVis1nhxXWjJrYnHRlBILmaNg3dX9cLetp3iwGoGEpLILIFIVGUF7V0KSEZsW+rCkJrMKQCJiZZCAiNU5NhKY38DSBMmqmqIrnCJh9lCdD6OdwBkXeCfgeB463aQhla/ZjCo+jPcIlOChoStOewVA0cY8QkkYkpEOZN1YT9JOnKJwmomSbtbFsBRDeBlXK2ZvgRoSFdlQIUjMn3aXTa/Vcny9uasAIajphhHMHwoEI+FAqG5OY7TakWPLn+UhogM9iUaOahUe2luAlIQ33waltdlIkuMgQpjDn9lhpFE2cM2ZO3A/TbUzTnMUH3fTHM1xHtKbFyqDipYA+s39MCUijwtpVRbKuqinbsWowUa8HXJ6dtRomAjV2c2/5iSQREGEmg+bUxNYFGhqwvwNigZkGc7DTbZrgcbjTQvqcJe3ivTSHjeDe4ELgiqKyW6UsZaledROtYrMiyZpyN6o6DXQ8BqO5obJ4cZQCsthLSDopke5et5hDqlWM6iZKCb1ZbIZV5gwiLCnh7eOwPBqXdfEeFKHwxZGT6Qp8mFAVUUeGz2ZzsVs+nQhH7ZM11XW4ejs7CQ6nYSiLXXQJEk5YvMbItwymACYoWvWekZfvPUCXExD4aCxEomsnlINX7qMXDUckJdifsbtoUlPlveRbvlHS/8hyMHsGFkR+aoQjuG5KsYLXbzbxTBMPgrEn81Rh+kGjIMUngBaB9RVCXAQ54w0SyagJvKs0yXQTo8Acb7KK+CMVxDwuIuvwikBQhLCeJzzev5PdXK7mR6BnAb1vKR63tK8vsMRiKpic50rmIjoK4JqMpWKefmu9hhQQ1VizNs8a9HCxlhNrGG+73aL4YbgayXRYCZq7F94tV6vIB3yY4IX4RQVNimSyKUKK8BOjW8Cmp6KQEkyBGMCGVDVUH6O6rzB+5fHxJ3hzt8V9R9dTzdEhcyULSxU5npkGACqSJg3EMEpCYdi1jowug9TvCTt9Zhwi0bjWlCoDZAZtCKf6TgJxYRLoBUcoUGkJDWj2SbCZgMWVTqgbNxnuqZIEtRaqDHXcyKR1EFcgoVW2HlIcBEU2GVLuUnSQ9GMa2zHEZe+SpcU2pGUl6PYFryzrtox8hvfb0n/qB5rH9lj3V9ktZLV5AyqgnyotHihrXjCFCTqkBCBQCBxqWx8umqQ6IApFYha0STLxde31ddOmRPeXvlMNHVsx4BlQs4Tw67F5IPDjwzjiqnxOS8O5NTrMyXUveVltJMy4k0aPTrFtJIV12dt1AO2yXsnH/yorLLkjUcrhl5sP+P+uvybWA1ZNqxktZZYbD1Wy6QLg5d+PTz15zcfe2vbzN6t2IEfn9/TN3Q11LDzTBt+5LcXeslng/YP57X2TV/YVYpmlPj6vx8KHz0ZUVZ27hsIfGnbfHb6yVMf7N76btkOJnB45+AK58cv3fPXT19dUF7buM59YM/+qcc/XZVY+apnfHjNZyeiE08vHvz8ifNXrO9JTz3Zf7x5f0t7X3kZRQ98cv/71erAqf6rbX9e7rlQfuJI4922LYOW2RX7fsHfBhu3XFlfUzlzdnD1c9+2Tfvu3NFz5TtP/HBk6JF3rt4n7+3fuPv0GrXW88rBTdPgweXVq6uJTZOjv/cuJw5tdpzv7r288phlQ9vZuRuOrlp3SZn9eNehl7/Y3n9x39wrT6/KxPJvW3TkT/wRAAA="
    
    /// Generates headers for API requests based on the country
    private func generateHeaders(for country: EbayCountry) -> HTTPHeaders {
        return [
            "Authorization": "Bearer \(CardsModel.apiKey)",
            "X-EBAY-C-MARKETPLACE-ID": country.rawValue
        ]
    }
    
    // MARK: - Initialization
    /// Initializes the model with a specific session for network requests
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    /// Performs a network request with the given URL components and headers
    private func performRequest(with components: URLComponents?,
                                headers: HTTPHeaders,
                                completion: @escaping (Result<Data, ErrorCase>) -> Void) {
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.getRequest(url: url, headers: headers) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    /// Creates URL components for a search query
    private func componentsForSearch(query: String) -> URLComponents? {
        var components = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "200"),
            URLQueryItem(name: "category_ids", value: "2536")
        ]
        return components
    }
    
    // MARK: - SearchCards method by name
    /// Searches for cards by name and country, handling the network request and response
    func searchCards(withName name: String, inCountry country: EbayCountry, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        /// Implements the logic to search for cards using eBay's API
        let trace = Performance.startTrace(name: "search_cards")

        let searchQuery = name.split(separator: " ").joined(separator: "+")
        
        let headers = generateHeaders(for: country)
        
        performRequest(with: componentsForSearch(query: searchQuery), headers: headers) { result in
            trace?.stop()

            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
                    completion(responseJSON.itemSummaries.isEmpty ? .failure(.noCardsFound) : .success(responseJSON))
                } catch {
                    print("JSON Decoding Error: \(error)")
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
