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
    
    // MARK: - Properties
    private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    // MARK: - API Key & Headers
    static let apiKey = "v^1.1#i^1#f^0#p^1#I^3#r^0#t^H4sIAAAAAAAAAOVYbWwURRi+65dp6mFIVZAPU5ZKKrh7s7e3d7fb3oVrS+FIP7lSShMps7uz7dK73XV3j/YialOUmBLCR/xKDKakBIOoPzQh4Yd8KZgIPxQ1qNGkP4wV0GKNgomKzt4d5VoJIL3EJt6fy7zzzjvP88z7zswO6C8qXrpt1barLuc9eUP9oD/P6aRLQHFR4bJZ+XnzCh0gy8E51F/eXzCQ/32VCeMxnV+DTF1TTVTWF4+pJp8yBomEofIaNBWTV2Ecmbwl8tFwQz3voQCvG5qliVqMKIvUBgmvLAFa9jAsIwQgLcjYql6P2aoFCUlg/X5G9MgcIwi0GMD9pplAEdW0oGoFCQ/wMCTgSI+vFfh5JsADlvIBbwdR1oYMU9FU7EIBIpSCy6fGGllYbw0VmiYyLByECEXCddGmcKR2RWNrlTsrViijQ9SCVsKc3KrRJFTWBmMJdOtpzJQ3H02IIjJNwh1KzzA5KB++DuYu4Kek5gSBob2QZgDtF2gJ5UTKOs2IQ+vWOGyLIpFyypVHqqVYydspitUQNiHRyrQacYhIbZn915KAMUVWkBEkVlSH14ebm4lQvWZAVUWrSVvtGmhIZPOaWpLlfIDzBPxekoMsgj7am5koHS0j85SZajRVUmzRzLJGzapGGDWaqo0nSxvs1KQ2GWHZshFl+3EZDVku0GEvanoVE1a3aq8rimMhylLN26/AxGjLMhQhYaGJCFM7UhIFCajrikRM7UzlYiZ9+swg0W1ZOu929/b2Ur0MpRldbg8AtLu9oT4qdqM4JLCvXetpf+X2A0glRUXEuYX9eSupYyx9OFcxALWLCHn9AQ8IZHSfDCs01foPQxZn9+SKyFWF4P1FCniB4AsAP5QYkIsKCWWS1G3jQAJMknFo9CBLj0ERkSLOs0QcGYrEMyzeBgMyIiUfJ5NeTpZJgZV8JC0jBBASBJEL/J8K5U5TPYpEA1k5yfWc5fmqHne4VVdaatm6eNTaXKcnksl2Turb1A71iE9p51qWrV/b2F7dXt8QvNNquCn5mpiClWnF8+dCALvWcyiCZlpImha9qKjpqFmLKWJyZi0wY0jN0LCSURSLYcO0SIZ1PZKbvTpn9P7lNnF3vHN3Rv1H59NNWZl2ys4sVvZ4EweAukLZJxAlanG3XesaxNcP29yZQj0t3gq+uc4o1phkmq0ipa+cVIouZW4WKQOZWsLAt22qyb6BtWo9SMXnmWVosRgy2uhp13M8nrCgEEMzrbBzkOAKnGGHLe3jWD/NBALstHiJqaO0c6ZtSbnYigtW3uW12j35Iz/kSP3oAedJMOA8mud0girwCL0YLCrKX1uQf+88U7EQpUCZMpUuFX+7GojqQUkdKkZeqeMqGH1V/GHVwcGea71PfFf5lCP7jWHocTB34pWhOJ8uyXpyAAtu9BTS981xeRhM3gf8TACwHWDxjd4C+sGC+y9dfedc+YaDg9t/L64gPaXXui+OrgSuCSens9BRMOB0RJ6nfiF37PtxzPmeXPFAtxsMFswnW4c7KjyPmSsKO+rOL527seey46ExYWtob7w/uPVU4/BsM3560Uezdo0bH3c+5yBXxy5sWDf8zb4j1sKH97Q9+tnFDbM/OXR4e8vB4d1nj19xv39stOprY9+JRv+ll1y7R45vHN9f8kr1h8+6lrw90n3ytwOnxCvN8wVu/KcLX1QuO1PUrrkGo/MqFr9V/rmjoTN64FN277Hz/PKlT56RXt71jBI8PbZwdOyFBSfmfiW7zpf+ybNb2NfP7Pq2dPnRusrLOz8o3/9H29NvrnNvWTJ/ZOTdi3O2Hi75uWvnr3tfzK/c8cZZz8Kh8WRdeYN07q/Xdtd/eWjWkfRa/g0vuTAW/REAAA=="
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // MARK: - Initialization
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    // MARK: - SearchCards method
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
