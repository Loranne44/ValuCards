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
    static let apiKey = "v^1.1#i^1#p^1#f^0#I^3#r^0#t^H4sIAAAAAAAAAOVYf2wTVRxv1w4cP9TI/EUmjJsGHF777npt72602G3M1exHS7tRFnW+3r2OY+3deffK1ohkjAQDEhX1D40Ql+CP8IdoiH8AUQTUPwYCRhSNKGCMogIiieFHxB93bRndJICsiUtsLmne933f930+n/f9vvfuQN+4suqVjSvPTraOLxnoA30lVis1EZSNK519o61kaqkFFDhYB/ru7rP3236co8NUUuXnI11VZB1V9qaSss5njT4ircm8AnVJ52WYQjqPBT4SaG7iaQfgVU3BiqAkicpgvY9AEMU5L+1mBCrhcVG0YZUvxowqPoIS2LhLdLtpkfN4BRYZ/bqeRkFZx1DGPoIGtIsEHEkxUYrljYcBDhft7iAq25GmS4psuDgA4c/C5bNjtQKsV4YKdR1p2AhC+IOBhkhrIFg/ryU6x1kQy5/XIYIhTuvDW3WKiCrbYTKNrjyNnvXmI2lBQLpOOP25GYYH5QMXwVwH/KzUDE2zbILlGOQR6TjyFkXKBkVLQXxlHKZFEslE1pVHMpZw5mqKGmrEFyMB51stRohgfaX5F07DpJSQkOYj5tUGFgZCIcLfpGhQltGDpKl2HdREMjS/nnRzHsDRrJchOehG0EMx+Yly0fIyj5ipTpFFyRRNr2xRcC0yUKOR2oACbQynVrlVCySwiajAjwZDGlId5qLmVjGNF8nmuqKUIURltnn1FRgajbEmxdMYDUUY2ZGVyEdAVZVEYmRnNhfz6dOr+4hFGKu809nT0+PocTkUrctJA0A5Y81NEWERSkHC8DVrPecvXX0AKWWpCEaZGv48zqgGll4jVw0AchfhZ7wsDdi87sNh+Uda/2Eo4OwcXhHFqpCEIAhUnPFygpcRKZYuRoX480nqNHGgOMyQKah1I6wmoYBIwcizdAppksi73AnaxSYQKXq4BMlwiQQZd4sekkogBBCKxwWO/T8VyrWmegQJGsJFyfWi5XljtzMQVaVwvbshFcFLGtR0JhPjxN7FMagGPVKMC89e2NYSq401NfuutRouS74uKRnKRI35iyGAWetFFEHRMRJHRS8iKCoKKUlJyIytBXZpYghqOBNByaRhGBXJgKoGi7NXF43ev9wmro938c6o/+h8uiwr3UzZscXKHK8bAaAqOcwTyCEoKadZ6wo0rh+muTOLelS8JePmOqZYGyRzbCUxd+V0ZOk69CWCQ0O6ktaM27aj1byBRZVuJBvnGdaUZBJp7dSo6zmVSmMYT6KxVthFSHAJjrHDlvJwjJcyXhHBqHgJ2aO0c6xtScXYiu0PXOe12jn8Jd9vyf6ofusu0G/dXmK1gjngHqoKzBhna7PbJk3VJYwcEkw4dKlLNt5dNeToRhkVSlrJFMtZcOxl4UTjxtXdf/Y89kPNE5bCbwwDD4M7hr4ylNmoiQWfHEDFpZ5S6qbbJ9MuwFEMxVIsAzpA1aVeO3WbvfzZb9c+N+Mg/NAesCeOHn7yXf15z2dg8pCT1VpqsfdbLf2de2sGLpyI3nUB7Hpv0xp1QvrR04032944UlZdvmDw7ekdL+5fvOWhzo/EdSdfsoT378C3rk+tca+mwltWHO86teKX6t+n7zn4xZIbyCA8Gfi+90xTV8XXS49bZs2tAp0Ltk9zf7X18ErbxFtC46PN02dOUya1VzcsDW89f4TbufeFQfX9j8+z/atWfeI7uLvqr7rNy7Y9wsx86/zyE4O1sTsPHe6bu9xWMem76J7yzR9s3m175vQ5VF6zdlbLTjZz7+uv/Hps/f3Lal47h5I/H/iU3/Gl55t3tm3fsPFzpqst6Gf3HXg1dPSPFeG5LmbfTwvaVj1e/+bTg+N/m79uwuq2nkMbdm566lTFfVO8Z3Jr+TdI9zq0/REAAA=="
    
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
