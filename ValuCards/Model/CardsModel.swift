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
    static let shared = CardsModel()
    
    // MARK: - Task for the request
    private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    // MARK: - Properties
    static let apiKey = "v^1.1#i^1#p^1#r^0#I^3#f^0#t^H4sIAAAAAAAAAOVYbWwURRi+a68lR1tRQCxo5FjECGT3dvc+d+2dubaUHvYL7mgOEiVzu7Pttne7685c2/tBLFWB1FTkSxMQU01EkRqjIQb5AQYjRn6Y2JigEBujyIeBaICA/QFx9+4o10oA6SU28bLJZd55553neeZ9Z2aX7i21L9lYv/FahXVa0WAv3VtktTJltL20ZOkDxUXzSix0noN1sPeJXltf8bkqBJIJjV8FkaYqCDp6kgkF8RljgEjpCq8CJCNeAUmIeCzwkVBjA89SNK/pKlYFNUE4wrUBwu/yMIwfevySCzA0AwyrcjNmVA0QjI8FLOfyiz4oCqLEGv0IpWBYQRgoOECwNOsiaY5kmCjD8h6v8VAeP72WcLRCHcmqYrhQNBHMwOUzY/U8rHeGChCCOjaCEMFwqC7SHArXLmuKVjnzYgVzOkQwwCk0vlWjitDRChIpeOdpUMabj6QEASJEOIPZGcYH5UM3wdwH/IzUbNwHpbggQdbnd0MQL4iUdaqeBPjOOEyLLJJSxpWHCpZx+m6KGmrEO6CAc60mI0S41mH+rUyBhCzJUA8Qy6pDa0ItLUSwQdWBosAVpKl2DdBFsmVVLenhvDTH+n1ukgMeCLyMOzdRNlpO5gkz1aiKKJuiIUeTiquhgRpO1Madp43h1Kw06yEJm4jy/dw3NfT51pqLml3FFG5XzHWFSUMIR6Z59xUYG42xLsdTGI5FmNiRkShAAE2TRWJiZyYXc+nTgwJEO8Ya73R2d3dT3S5K1ducLE0zzlhjQ0Roh0mjGHuSZq1n/eW7DyDlDBUBGiORzOO0ZmDpMXLVAKC0EUG3z8/S/pzu42EFJ1r/Ycjj7BxfEYWqEM7YZjgP4xEYLh73+sRCVEgwl6ROEweMgzSZBHonxFoCCJAUjDxLJaEui7zLI7EuvwRJ0ctJpJuTJDLuEb0kI0FIQxiPC5z//1Qo95rqESjoEBck1wuW5/WdzlBUk1fWeuqSEdxVp6XS6Rgn9nTEgBb2yjFu5dI1q5ti1bGGxsC9VsNtydckZEOZqDF/IQQwa72AIqgIQ3FS9CKCqsEWNSEL6am1wC5dbAE6TkdgImEYJkUypGnhwuzVBaP3L7eJ++NduDPqPzqfbssKmSk7tViZ45ERAGgyZZ5AlKAmnWatq8C4fpjmdRnUk+ItGzfXKcXaIJllK4vZKyeVoUuhLoHSIVJTunHbpprNG1hU7YSKcZ5hXU0koN7KTLqek8kUBvEEnGqFXYAEl8EUO2wZL+d2u3w0450ULyFzlK6baltSIbZi2/L7vFY7x7/kBy2ZH9NnPUr3WQ8XWa10Fb2IWUgvKC1ebSsun4dkDCkZSBSS2xTj3VWHVCdMa0DWi2ZZrtFndwsX6vf1d97ofuHM0+st+d8YBp+jK8e+MtiLmbK8Tw70Y7d6SpgZj1SwLppjGIb1eD3etfTCW702Zo5t9rU9p4h32VT1ngMfxF2fzXJsnzsX0xVjTlZricXWZ7XMvNKq2+wn64+Im7f4f9hSue3J+Yfs8y8fn0seGPh9ZEd16O2igd7yn4+OngK1zakdjy54fANd+Vpb2cVB4lvL6dFlx/+4dHFjV5/WQaVvzNw0fOKnrl9/6Y9VvGRXr84Y/E1/Z+vW8lcv9R8r+lp3TEPPl1+5MDwS3Tn0/XT4bKW0Ysvwy9vRw29spg/uv77j9Jn3zp+w7/rCMVCyYWGpsje8YF/V8m3nbQdOVX/FP/Th5bfKhs6OnpkNBl7kRz5685u9J98fOtQUPzK8eOauk8c2/fjn1Y7r/JL+c00fr9jZuDtxcH/P+tfnfPoJOBx+hhz9buipv7ZXfr6oa/rWVx78sl1eXDyy4WCN3Wsvya7l3wR+fnP9EQAA"
    // Grand Central Dispatch pour les différents réseaux (asynchrone)
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        let searchQuery = name.split(separator: " ").joined(separator: "+")
       
        var components = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
            components?.queryItems = [
                URLQueryItem(name: "q", value: searchQuery),
                URLQueryItem(name: "limit", value: "3"),
                URLQueryItem(name: "category_ids", value: "2536")
            ]

        guard let url = components?.url else {
            completion(.failure(.invalidURL))
                return
            }
        
        task?.cancel()
        print(url)
        session.getRequest(url: url, headers: headers) { result in
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
                    
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

// Google Goggle
// Plutot passer par des webService type Google Lens ? Chat Gpt 4 ? Que CoreML

// Nettoyer l'image comme note; mise a plat d'image

