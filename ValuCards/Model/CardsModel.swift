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
    static let apiKey = "v^1.1#i^1#I^3#f^0#p^1#r^0#t^H4sIAAAAAAAAAOVYa2wUVRTu9qUFi0beiLoMjyhkZu7sY3Zm2l3dttQu9smWumxCyN2Zu3TY2Zlh5m7bJahNMZVXIJoaAsakGoUoJkhsqBofhB80MRg0JsbgHxJSIBFB8NEQiTqzXcq2EkC6iU3cP5s599xzv++759x7ZkB3adny3rrekXLHfYX93aC70OFgpoOy0pIVM4oKF5QUgBwHR3/3ku7inqILlSZMKrqwGpm6pprI2ZVUVFPIGP1EylAFDZqyKagwiUwBi0I42FAvuCgg6IaGNVFTCGeoxk9wrA+wCCHOJXEuD+uyrOqNmK2an4i7+RjkfDHOLUkwBr3WuGmmUEg1MVSxn3ABl5sEPMnwrYATPLzAsBTgPFHC2YYMU9ZUy4UCRCADV8jMNXKw3h4qNE1kYCsIEQgFa8NNwVDNysbWSjonViCrQxhDnDLHP1VrEnK2QSWFbr+MmfEWwilRRKZJ0IHRFcYHFYI3wNwD/IzUIoc4H/KwXoYDoiVrXqSs1YwkxLfHYVtkiYxnXAWkYhmn76SopUZsIxJx9qnRChGqcdp/LSmoyHEZGX5iZVVwbbC5mQjUawZUVbSKtNWuhoZENq+uIb08C3gX5/OQPPQiyDKe7EKj0bIyT1ipWlMl2RbNdDZquApZqNFEbdw52lhOTWqTEYxjG1GOHwPGNARRe1NHdzGF21V7X1HSEsKZebzzDozNxtiQYymMxiJMHMhI5CegrssSMXEwk4vZ9Oky/UQ7xrpA052dnVSnm9KMDbQLAIaONNSHxXaUhITla9f6qL985wmknKEiImumKQs4rVtYuqxctQCoG4iAx8e5AJfVfTyswETrPww5nOnxFZGvCoFx5HJLwAtinMcDfWI+KiSQTVLaxoFiME0moZFAWFegiEjRyrNUEhmyJLi9cZebiyNSYvk46eHjcTLmlViSiSMEEIrFRJ77PxXK3aZ6GIkGwnnJ9bzleV2CDrbqckuNtzYZxh21eiqdjvBS18YI1EOsHOFbVqxd0xipitQ3+O+2Gm5JvlqRLWVarfXzIYBd63kUQTMxkiZFLyxqOmrWFFlMT60NdhtSMzRwOowUxTJMimRQ10P5OavzRu9fHhP3xjt/d9R/dD/dkpVpp+zUYmXPN60AUJcp+waiRC1J27WuQav9sM3rM6gnxVu2OtcpxdoiOcpWlkZbTipDlzI7RMpAppYyrG6barI7sFYtgVTrPsOGpijIaGMmXc/JZArDmIKmWmHnIcFlOMUuW4blvQzjdnvZSfESM1fp+ql2JOXjKC5+5h7banr8S36gIPNjehzHQY/j80KHA1SCpcxisKi0aE1x0QMLTBkjSoZxypQ3qNa7q4GoBErrUDYKZxaMgPOvixfr3t2R+LNz07mK5wtyvzH0rwPzxr4ylBUx03M+OYCFN0dKmAfnlrvcgGd4q63kGTYKFt8cLWbmFM/aNPhZRfziAeLgtr6WgfMH3t/r2cKD8jEnh6OkoLjHUfDIt3vOzK0qn/PD/kI6/Mn+2j8en7NpcPuPsc24RxnYOrSzYkfb0w/v7TtxrO3ayoMPhX/3n3x1UbW08fThr5hvDidO7fv1gzfeXFa65+fd84YHZ25/O/ZCBPSEGs5eXn35ki/6Ucdv3119T9k9AK/QZc9d2Xtg1lOn76+ofnlVYPsXf5U1vjTXX7tu1fzvT1SOlM5Gu4hF3Y/x6flG49ljP53jZz965dm3FoKB9q17Roa/Nrb0Hl/Xfr2X2HXpywtHwZBxaGliH/dER+cv/XVLdi0Lb358y7ajQ/Wn6J1nPj1z9JVpH167eFL5mN+/NcoOLbw+7dSR+eTw8iOh4XeifRVron0znnyxdPA19dBVcnQv/wa4O+Mk/REAAA=="
    
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
