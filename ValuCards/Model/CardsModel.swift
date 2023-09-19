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
    static let apiKey = "v^1.1#i^1#I^3#p^1#r^0#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTutt2a8pSHQCjROoVoxJm9M/vozrRds7SULva9pSkF09ydudMO3Z0Z5t6lXQ2kVkNMfUT9UUEMICqGUBQkEsVXIIoSA0jwl0ENCQ+NmgghwB/QO7tL2VYCSDexiftnM+eee+73feece+8M6CsofGR9zfrLkx335G7tA325Dgc/ERQWOBdOycud68wBGQ6OrX3z+/L7834pxzAWNaVmhE1Dx6i4NxbVsZQ0VjBxS5cMiDUs6TCGsERkKRysq5UEDkimZRBDNqJMcaiqghHdvCp7FH9E8PIQeBRq1a/HbDHoeKnbLUTcqpdX/TDiB3Qc4zgK6ZhAnVQwAhDcLBBZXmzhBYn3SR6R8wq+dqa4FVlYM3TqwgEmkIQrJedaGVhvDRVijCxCgzCBULA63BAMVS2ubyl3ZcQKpHUIE0jieORTpaGg4lYYjaNbL4OT3lI4LssIY8YVSK0wMqgUvA7mLuAnpYalMvSX8rKAZOjjBW9WpKw2rBgkt8ZhWzSFVZOuEtKJRhK3U5SqEVmFZJJ+qqchQlXF9l9THEY1VUNWBbN4UXB5sLGRCdQaFtR1tJS11a6ElsI2NlexXtEHRMFf6mFF6EWUsye9UCpaWuZRK1UauqLZouHieoMsQhQ1Gq0NyNCGOjXoDVZQJTaiTD/PsIZ8u53UVBbjpEu384piVIji5OPtMzA8mxBLi8QJGo4weiApEc21aWoKM3owWYvp8unFFUwXIabkcvX09HA9bs6wOl0CALyrra42LHehGGSor93rKX/t9hNYLUlFRnQm1iSSMCmWXlqrFIDeyQQ8pX4B+NO6j4QVGG39hyGDs2tkR2SrQzwyAB6/qkSQKpcq/mw0SCBdoy4bBorABBuDVjciZhTKiJVpmcVjyNIUye1VBbdfRaziE1XWI6oqG/EqPpZXEQIIRSKy6P8/9cmdVnoYyRYiWSn1rJV5Tbcr2GJqTVXe6liYrKk244lEm6j0rmqDZsintYlNC5cvq29b1FZbV3GnzXBT8pVRjSrTQtcff71eY2CClDHRC8uGiRqNqCYnxleC3ZbSCC2SCKNolBrGRDJomqHsbNVZo/cvt4m74529I+o/Op5uygrbJTu+WNnzMQ0ATY2zTyBONmIuw+51SG8ftrkjiXpMvDV6cR1XrCnJFFtNSd04OcOmy+E1MmchbMQtetnmGuwLWIvRjXR6nhHLiEaR1cqPuZ9jsTiBkSgab42dhQLX4Dg7bHmf6KVvM34gjomXnDxKO8bblpSVrTi/+u5u1a6R7/iBnOSP73ccBP2Oz3MdDlAOFvAl4MGCvGX5eZPmYo0gToMqh7VOnb66WojrRgkTalbujJzL4Nwm+feaHQPd13pWny1bm5P5iWHrE2DO8EeGwjx+YsYXBzDvxoiTnzp7suAGIi/yAu/ziO2g5MZoPj8rf+ZfYe7kxqIND71z7Nc/D+z/ZOPLhxc8DyYPOzkczpz8fkfO7P17t+97eOjnQqamdv4SLA88W1ddT1aUn565snl64r3DX6x7sv/9M0N75sh7mro2Ob7dtvot0b99d7j11IW9eT/t8Igf/3E8+MCc+GBB4YyioxtKNn9TdMY77/tA+9kX331q32MfnWie5mk9FOk43nHoRNWFo1d3PzP92XVNP8SWLvjyynfblNc+nHa+5NPz2ya82QDPfXX169M5ZSenTnvjpYtTy8qO7LzvyL3LOl4/XaS9jY8VOAeW4HWDK3fOmjS05RB87rcpEcO5Rhc2By5tOeiW97p2XZzRfP/GKx88enb6iooDp9YPRX9MLDYrB1cPPn5p18pXr63ddbD0zGcDneH9Tzt3OnpeWNj9yoR9B1K5/Bs4nszF/BEAAA=="
    
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
