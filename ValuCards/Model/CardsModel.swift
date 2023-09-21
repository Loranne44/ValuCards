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
    static let apiKey = "v^1.1#i^1#f^0#I^3#p^1#r^0#t^H4sIAAAAAAAAAOVYe2wURRi/612rCJVEsWJj4rmgCZbdm9291y69w2tLabX0wR3kIArM7c7C0rvdZXe27RmRpiIq8REMaiIk4AvlYRAfAUOCxIga1AiB0ER8YgIVJdqgEIyCu3dHuVYCSC+xiffPZb755pvf7zffNzM7oLts1F0rGlacLndeU7K+G3SXOJ30aDCqrLTqeldJZakDFDg413dP7Hb3uPqqDZhOafxMZGiqYiBPVzqlGHzWGCZMXeFVaMgGr8A0Mngs8LHojCaeoQCv6SpWBTVFeBrrwgTtC3BAYlgk+aDoB5ZROR8yroYJKcAyUKAlH0IoIAmM1W8YJmpUDAwVHCYYwLAk4EiGjgOOZ1kesJSfDs4lPLORbsiqYrlQgIhk0fLZsXoB1EsjhYaBdGwFISKN0fpYS7SxblpzvNpbECuSlyGGITaNwa1aVUSe2TBloktPY2S9+ZgpCMgwCG8kN8PgoHz0PJirgJ9TGkHRUtufDAY5AYakokhZr+ppiC+Nw7bIIillXXmkYBlnLqeopUZyMRJwvtVshWis89h/bSZMyZKM9DAxrSY6J9raSkSaVB0qCrqHtNWuhbpIts6sI/1cAHBMKOgjOehHMED78hPlouVlHjJTraqIsi2a4WlWcQ2yUKOh2jAF2lhOLUqLHpWwjajAj6YHNGTm2ouaW0UTL1LsdUVpSwhPtnn5FRgYjbEuJ02MBiIM7chKFCagpskiMbQzm4v59OkywsQijDXe6+3s7KQ6WUrVF3oZAGhvYkZTTFiE0pCwfe1az/rLlx9AylkqArJGGjKPM5qFpcvKVQuAspCI+IIhBoTyug+GFRlq/YehgLN3cEUUq0IYKRhAEAVZQfL5BcgWo0Ii+ST12jhQEmbINNTbEdZSUECkYOWZmUa6LPKs39oFQxIixQAnkT5OksikXwyQtIQQQCiZFLjQ/6lQrjTVY0jQES5OrhcrzxvavdG4JrfV+evTMdxRr5mZTIITuxYnoNYYkBNcW9WcWc2JmkTTjPCVVsNFydemZEuZuDV/UQSwa714IqgGRuKw6MUEVUOtakoWMiNrgVldbIU6zsRQKmUZhkUyqmmNRdqri0XvX24TV8e7iGfUf3M+XZSVYafsyGJljzesAFCTKfsEogQ17VXtWofW9cM2z8+iHhZv2bq5jijWFskcW1nMXTkp1aZLGR0CpSNDNXXrtk212DewuNqOFOs8w7qaSiF9Nj3sek6nTQyTKTTSCrsICS7DEXbY0gHOz4RCwRA7LF5C9iidP9K2pKJsxe76q7tWewd/40cc2R/d4/wA9Dh3lTidoBrcQU8At5e5ZrldYyoNGSNKhhJlyAsV69tVR1Q7ymhQ1ktudJwGx9YIPzdsXNl+tnPJ0SlLHYVPDOvvB+MHHhlGuejRBS8O4NYLPaX02JvLGdYiTwOOZQE7F0y40OumK9zjepUPnaWVff3TOw6eEPdvfjnpP7kTlA84OZ2lDneP02GOfeuP3U9WeU5vmvjwlqZ92/tmVTz4WdnvvpW+ZdNa3I83LLj220++2nm847WtFdvuPHYbtcNVtmCD67qQNDnz4xrnD+K5zadqHjXRkUl/TQ4d3XdY7e8Yt2vZn++uWk69eWbsgbK3XxcmPN38U2/diYduOF69fd5No9XeX8ZNDT03T9j6vveZzcGj1CR16SvPxm5Z+1tw9QMV8UPxFxr6X+XIU2f8m3pbz74x/t4jW47cvWr/4e/a6alL9npKV5j9Y/Z8/cV99PiP9mx7p3L/knOwd917U3d+v7vCv/HLbyo//fWlrcYjy190U76DmdV71qV2JKbEPq86vnfe4nLH9ENPPWEeWKvWfHyy7/m2+Z0bHsut5d/KxnUr/BEAAA=="
    
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
