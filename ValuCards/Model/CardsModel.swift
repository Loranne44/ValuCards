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
    static let apiKey = "v^1.1#i^1#f^0#r^0#p^1#I^3#t^H4sIAAAAAAAAAOVYe2wURRi/R4vWUhoCKhJjjqWND7y92b3nrr2z1xc9Wvrg2uZaAzi7O9vb3t3usjvH9TTGUhHENKFGo4j+gYZATERJiEZDMGg0CgmSIBFEJZgoEjRKfKEoxN27Uq6VANJLbOLtH5f55ptvfr/ffN/M7IKhGWX3rGted7bCeoNtyxAYslmtVDkom1G6aJbdNr/UAgocrFuGqoZKhu2nanSYSqrsMqSriqwjx2AqKetszhgk0prMKlCXdFaGKaSzmGej4aWtLE0CVtUUrPBKknBEGoIEJXABgTMeATKiR+QNq3wxZpcSJAQ3R0POxwtezuvzAc7o1/U0isg6hjIOEjSg3U7AOKlAF/CzdID1ekngo/sIRw/SdEmRDRcSEKEcXDY3VivAemWoUNeRho0gRCgSboq2hyMNjW1dNa6CWKExHaIY4rQ+sVWvCMjRA5NpdOVp9Jw3G03zPNJ1whXKzzAxKBu+COY64OekRiLy+2kKCIyHEYFHKIqUTYqWgvjKOEyLJDjFnCuLZCzh7NUUNdTgBhCPx1ptRohIg8P860zDpCRKSAsSjXXh3nBHBxFqVTQoy2iJ01S7HmqCs2NZg9PL+ABDB/weJwO9CPooz9hE+WhjMk+aqV6RBckUTXe0KbgOGajRZG2oAm0Mp3a5XQuL2ERU6Mdc1NAb6DMXNb+KaRyXzXVFKUMIR6559RUYH42xJnFpjMYjTO7ISRQkoKpKAjG5M5eLY+kzqAeJOMYq63JlMhky4yYVrd9FA0C5Yktbo3wcpSBh+Jq1nveXrj7AKeWo8MgYqUsszqoGlkEjVw0Acj8R8vgDNAiM6T4RVmiy9R+GAs6uiRVRrAoR/FzAHeAZjhH9Io9gMSokNJakLhMH4mDWmYJaAmE1CXnk5I08S6eQJgms2yvS7oCInIKPEZ1GiYpOziv4nJSIEECI43gm8H8qlGtN9SjiNYSLkutFy/PmhCvcpUqdDd6mVBSvblLT2WyMEQYHYlCN+KQY07mot7stVhdrXRq81mq4LPn6pGQo02XMXwwBzFovogiKjpEwJXpRXlFRh5KU+Oz0WmC3JnRADWejKJk0DFMiGVbVSHH26qLR+5fbxPXxLt4Z9R+dT5dlpZspO71YmeN1IwBUJdI8gUheSbnMWlegcf0wzStzqKfEWzJurtOKtUEyz1YS8ldOMkeX1FfzpIZ0Ja0Zt22y3byBdSkJJBvnGdaUZBJpPdSU6zmVSmPIJdF0K+wiJLgEp9lhS/kYL6Bpyu2dEi8+d5SunG5bUjG24pLF13mtdk18yQ9Zcj9q2PoeGLa+Y7NaQQ2ophaCBTPs3SX2mfN1CSNSgiKpS/2y8e6qITKBsiqUNNscy1nw7Qv8982vPJm4kFl18r5HLIXfGLYsB/PGvzKU2anygk8O4PZLPaVU5a0VtBswVAD46YDX2wcWXuotoW4pmTtr5t0PjTSuOTPsqDp8/tna6vZD8d2gYtzJai21lAxbLb2jkd4n+s/gU2tql7do29PHfyzNbNsk8fvfPBLo69y8TxuZNdN/Mt7354Fq/5GEumfXXZ4F586/dePASz98aXnq9M3fLUuMNH8gbF5fDX8v7/8pc+LdTYe2fdW9oiUy+tHR7gc9i+P4WFnH4frRwW/sz6/Y/tvwyPw7Pz5nj5bPSdhmWxe+/dlruw5u2Gi7o8Xf8/KeuspHV5U+Q/mjto27Nxxrsejr42fWvr8zOHTi1IHb3L8+UNEwQG7d+smHn9Z88fPnx9+Yu/a5nvtfLVfOHpn3x2OV2r6jp1Ut9vWJ11/cGb9wdHSHf3Pl7HvFv1rJeWX791Lrqx4+2Lzj6droTY5z+7O1S37pO7B37eNV+bX8G3kKxyT9EQAA"
    
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
