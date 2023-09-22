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
    static let apiKey = "v^1.1#i^1#f^0#p^1#r^0#I^3#t^H4sIAAAAAAAAAOVYa2wUVRTubh+mYn2CGKxSB/qnOLN3Znd2d0Z2w9IHXSl9sG1TmijenblTpjs7M87cpV0oUJvYICJBoAlqTQpKFF9BDWpiBDExxfhIFDS06j8CSEQSDKKQgDO7S9lWAkg3sYn7ZzPnnnvu933nnHvvDOgtKq7or+0/V+K4xTnUC3qdDgc9DRQXFc67Pd85qzAPZDk4hnrn9hb05Z+Yb8K4ovNLkalrqonKuuOKavIpY4BIGCqvQVM2eRXGkcljgY+EltTxDAV43dCwJmgKURauChDuKJS8HPCKrEeKcsBnWdXLMZu1AOFhol4GcJKH8/hpn5u1xk0zgcKqiaGKAwQDGDcJOJJhmoGXZzmeZSnAeNqJslZkmLKmWi4UIIIpuHxqrpGF9dpQoWkiA1tBiGA4VBNpCIWrquub57uyYgUzOkQwxAlz/FOlJqKyVqgk0LWXMVPefCQhCMg0CVcwvcL4oHzoMpibgJ+SmvZzkPNCH+MT/aIAQE6krNGMOMTXxmFbZJGUUq48UrGMk9dT1FIj2okEnHmqt0KEq8rsv6YEVGRJRkaAqF4YWhZqbCSCdZoBVRU9StpqV0JDJBuXVpEs5wUc4/d5SA6yCHppT2ahdLSMzBNWqtRUUbZFM8vqNbwQWajRRG08WdpYTg1qgxGSsI0o289/WUOaa7eTms5iAq9Q7byiuCVEWerx+hkYm42xIUcTGI1FmDiQkihAQF2XRWLiYKoWM+XTbQaIFRjrvMvV1dVFdbkpzehwMQDQrrYldRFhBYpDwvK1ez3tL19/AimnqAjImmnKPE7qFpZuq1YtAGoHEfT4/AzwZ3QfDys40foPQxZn1/iOyFWHSFG3INBRPyPRUORofy46JJgpUpeNA0VhkoxDI4awrkABkYJVZ4k4MmSRd7MS4/ZLiBS9nER6OEkio6zoJWkJIYBQNCpw/v9To9xoqUeQYCCck1rPWZ3XxlyhZl1uqmJr4hG8skZPJJNtnNjd2Qb1sFdu45rmLWupb1vYVrckcKPdcFXylYpsKdNsrZ8LAexez6EImomROCl6EUHTUaOmyEJyaiXYbYiN0MDJCFIUyzApkiFdD+dmr84ZvX+5Tdwc79ydUf/R+XRVVqZdslOLlT3ftAJAXabsE4gStLjL7nUNWtcP27w8hXpSvGXr5jqlWFsk02xlMX3lpFJ0KXOlQBnI1BKGddumGuwbWLMWQ6p1nmFDUxRktNKT7ud4PIFhVEFTrbFzUOAynGKHLe3lWLeX5Th2UryE1FG6fKptSbnYigsW3eS12jX+JT+Yl/rRfY7PQJ9jn9PhAPNBOT0HPFSU31KQf9ssU8aIkqFEmXKHar27GoiKoaQOZcN5T945cPwl4dfa3RtiF7uePPbImrzsbwxDj4H7xr4yFOfT07I+OYDSKyOF9B0zSxi3RZ4BVs5Zth3MuTJaQN9bMD24Ze7BwZ2reg7zLdW8/8FTHWsHe0DJmJPDUZhX0OfIK5Vff+PVmtlHS/5aVbyj4+jjPw7sLt7sRGd6B94dLq1855LRoGzdt63nxT0LvvyjqWXe2kPPHL60yDPjLXLNfj+5wPHNgs9bNx1fv8r53K6Tr7krzgy33rmhfN3J9tVvfnHr+thGfG7lSEXp9PM/xLf9NuJ8YPDugy1NXOuH243Tzx5z136wCS+9uPt3+uS3A8X7nx8omeE/MvJLibZ58dnzo85XNpQP3fXMEw/PVKrP1phvf33AObxrdNOF5JaiziN/Lh5drI2eaiz9NHbIse6TA1UfU2tf+Cm2ZzZ34sSF93Z+/93WvcOh0/d/5D7WUznyfv/PGwu/qvZdWr39VLQ/Pn2wc4dR/nTFy9TeLY6nitO5/BvYs51G/REAAA=="
    
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
