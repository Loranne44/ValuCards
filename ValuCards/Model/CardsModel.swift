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
    static let apiKey = "v^1.1#i^1#I^3#f^0#p^1#r^0#t^H4sIAAAAAAAAAOVYbWwURRjuXa+FprSiGGiQ6LE9IgFvb/b2bru7cBevX7Smn1xbC8bA3O5cu7273XVnjvZ+aEqNGJDAL4hi0GJNKFGL8YMYqkRB/CApakxIFH8QUSBiNH4g/NDG3etRrpUA0kts4mWTy7zzzjvP88z7zswu6C8sWrGlbsvlEtsc+2A/6LfbbEwxKCosWFmab19ckAeyHGyD/a5+x0D+hdUYJuK6uBZhXVMxcvYl4ioW08YAlTRUUYNYwaIKEwiLRBLDocYG0UsDUTc0oklanHLWVwcoTvAKkj8a9QtshJUEn2lVr8Zs0wIUL0NYwbEVPPD6fZzZi3ES1auYQJUEKC/wsm7Au1mmDfAiYz6A9gn8esrZgQysaKrpQgMqmAYrpscaWUhvDBRijAxiBqGC9aHacHOovrqmqW21JytWMKNCmECSxFNbVZqMnB0wnkQ3nganvcVwUpIQxpQnODHD1KBi6CqY24CfFloCXjnKM0Dm5Ao/A705kbJWMxKQ3BiHZVFkdzTtKiKVKCR1M0VNNSI9SCKZVpMZor7aaf21JmFciSrICFA1laF1oZYWKtigGVBV0UNuS+0qaMjulrXVbr/AAcHLV/jcAvQjyDG+zEQT0TIyT5upSlNlxRINO5s0UolM1Gi6NiBLG9OpWW02QlFiIcryY8CkhmC9tagTq5gk3aq1rihhCuFMN2++ApOjCTGUSJKgyQjTO9ISBSio64pMTe9M52ImffpwgOomRBc9nt7eXrqXpTWjy+MFgPF0NjaEpW6UgFTa16p1y1+5+QC3kqYiIXMkVkSS0k0sfWaumgDULiroq+C9gM/oPhVWcLr1H4Yszp6pFZGrChE4LsJG/byfQ4KPQxW5qJBgJkk9Fg4UgSl3AhoxRPQ4lJBbMvMsmUCGIousP+pl+Shyy5wQdfuEaNQd8cucm4kiBBCKRCSB/z8Vyq2mehhJBiI5yvUc5XldzBNq05XWan9tIkw21erJVKpTkPt6OqFezymdQuvKde1NnZWdDY2BW62G65KviiumMm3m/LkRwKr1nImgYYLkGdELS5qOWrS4IqVm1wKzhtwCDZIKo3jcNMyIZEjX63O1V+eI3r/cJm6Pdy7PqP/kfLouK2yl7OxiZY3HZgCoK7R1AtGSlvBo0Kp18/phmTekUc+It2LeXGcVa5PkBFtFnrhy0ho06dJ4k0QbCGtJw7xt083WDaxNiyHVPM+IocXjyOhgZlzPiUSSwEgczbbCzkGCK3CWHbYMJ7A+TuAFMCNeUvoo3TDbtqTcbMWOmtu6VnumvuIH89I/ZsB2FAzYjthtNrAaLGPKwdLC/HZH/rzFWCGIVmCUxkqXar67GoiOoZQOFcO+IO8yOP+89GPdgW2x8d7Hzq16PC/7C8Pgo6Bs8htDUT5TnPXBASy51lPA3LGoxMsCnmUAz5hvs+tB+bVeB7PQcXfJHye+oXeNDQ2ffPfiipP696/vv3IGlEw62WwFeY4BW94jfWvU8JPty/7a7LxypWVsqat24yXyUar4tfaHYx+49hweett/avld4aG9pdLw+Hb51J9zx4OpIfubgVRfgeuHM2tP41+fRkdfemDB++c6NjpOPXih5pNDjWXd+CxKHjwvfbsvVlrqOtYaeGeRyhaHPj0rwtGfhr/WDn6hHNrLi6ePH1i4b/7mF+/purP5hcXMie09wztG9rx3rz46OtT6RNnSXZffcp39bPDL3R+O2vb3VBZufbboVbVu53flrleeOVKizP35lxH2/jfKd646/vn830bWPPWc/HHy5WPbti7Zean8vsPKeMXFLau+kuWxdUUHe/ZdzC8bGLNf2DHYbA/O3bsj//eRrXOWz5tYy78BP2AVGPsRAAA="
    // Grand Central Dispatch pour les différents réseaux (asynchrone)
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
       
        let searchQuery = name.split(separator: " ").joined(separator: "+")
            let urlString = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(searchQuery)&limit=1&categoryId=183454"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.errorDecode))
            return
        }
        
        print(url)
        
        task?.cancel()
        
        session.getRequest(url: url, headers: headers) { result in
            
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
                    let filteredItems = responseJSON.itemSummaries.filter { $0.leafCategoryIds.contains("183454") }
                            
                            // Create a new instance of ItemSearchResult with filtered items
                            let filteredResponse = ItemSearchResult(href: responseJSON.href,
                                                                    total: filteredItems.count,
                                                                    next: responseJSON.next,
                                                                    limit: responseJSON.limit,
                                                                    offset: responseJSON.offset,
                                                                    itemSummaries: filteredItems)
                                                                    
                            completion(.success(filteredResponse))
                } catch {
                    print(error)
                    completion(.failure(.errorDecode))
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

