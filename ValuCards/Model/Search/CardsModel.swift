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
    static let apiKey = "v^1.1#i^1#I^3#p^1#r^0#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTublu0lkehDRRCpA4okTK7d2bfY3fN9gVLyvaxC5YShbszd+jQ2Zlh5i7tRg1rIchDAz9EfiBKGrTxgQkmIBFUQgwGTQg/0ESjqEFNNRQBYzSixjvTpWwrAaSb2MSdH5t77rnnnu8759x7ZkBmQsmCzYs3/zrJdpd9XwZk7DYbUwpKJhRXTy60zyouADkKtn2ZeZmi3sKBGgMmZY1rQ4amKgaq6knKisFZwiCV0hVOhYZkcApMIoPDPBcLL23iWAfgNF3FKq/KVFWkPkgxALHQBVhfwgd5j08gUuWazbgapHysl2USCa+XDwis243IvGGkUEQxMFRwkGIB66IZlgb+OPBzgOVYj8MH2A6qajnSDUlViIoDUCHLXc5aq+f4enNXoWEgHRMjVCgSbow1hyP1DdF4jTPHVijLQwxDnDJGjupUAVUth3IK3Xwbw9LmYimeR4ZBOUNDO4w0yoWvOXMH7ltUe/1u0edlRSbgCkAx4MsLlY2qnoT45n6YEkmgRUuVQwqWcPpWjBI2EmsRj7OjKDERqa8y/1pTUJZECelBqqE2vCLc0kKFmlQdKgpaQpts10FdoFva6mlPwAsCrN/npgPQg6CXcWc3GrKWpXnUTnWqIkgmaUZVVMW1iHiNRnLj4zw53BClZqVZD4vY9ChHjwFZDr0Bb4cZ1KEopnCnYsYVJQkRVdbw1hEYXo2xLiVSGA1bGD1hURSkoKZJAjV60srFbPr0GEGqE2ONczq7u7sd3S6Hqq9xsgAwzvalTTG+EyUhRXTNWh/Sl269gJYsKDwpU6LP4bRGfOkhuUocUNZQIbfPzwJ/lveRboVGS/8hyMHsHFkR+aoQnvF7RI8Q8LpAgnG7XPmokFA2SZ2mHygB03QS6l0IazLkEc2TPEslkS4JnMsjsi6/iGjBGxBpd0AU6YRH8NKMiBBAKJHgA/7/U6HcbqrHEK8jnJdcz1ueL+5yhuOa1FrvaUzG8PpGLZVOtweEnrXtUIt4pfZAa/WKZdH22vampcHbrYYbgq+TJcJMnOyfDwLMWs8jCaqBkTAmeDFe1VCLKkt8enwF2KULLVDH6RiSZSIYE8iwpkXyc1bnDd6/PCbuDHf+7qj/6H66ISrDTNnxhcpcbxADUJMc5g3k4NWk06x1FZL2wxSvsrweE26JdK7jCjUBOYRWEoZaTocF12Gs5x06MtSUTrptR7PZgcXVLqSQ+wzrqiwjfTkz5npOJlMYJmQ03go7DwkuwXF22TKkvwAs63F7xoSLt67SVePtSMrHUVy06A7baufIl/xQgfVjem0nQK/tPbvNBmrA/cxccN+EwmVFhRNnGRJGDgmKDkNao5B3Vx05ulBag5JuLy+40rdrcd2shubnFzweT5/Z82HBxJxvDPseBZXDXxlKCpnSnE8OYPb1mWJmyoxJrIshWUweEvUOMPf6bBEzvahCn/bD28G9U9unX6jYcfBgP9thP74VTBpWstmKC4p6bQUtA4dPTBuc+dULD9wbPKfu2F/W06dcXrfhj67MG6+pnxzfu3v++WK/sqF/oW9Kw9O9f54qj+q/db8zf7b8e5sb6yVl/d+6TqmrT56d8/mZZ5bM/uBY2dmjDx2ak5hYaYvuZDcO1v3yLr+rr3XyE4f3HPj4m51ff5TaVFl+Ve/aWH2p6Vz3q/aB/TMXve779OGX6o/P2fr9pZWRhv7B3ScHBrbcHeNrnnu5VK+0nb684MKTjyTL/oqu7Ft4avC7tqemVrj7izdt+dn5JY16v/jpSurijNXbX5l39UT1Z1sOivccsx9Bi2orTr5YeuTQ5c7H3hLkvtqj3efDzx7NJC6+eQA9ePr9bdvKC9ZtmPpj35GhWP4NeL1dOP0RAAA="
    
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
