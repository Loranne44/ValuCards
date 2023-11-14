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
   // private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    // MARK: - API Key & Headers
    static let apiKey = "v^1.1#i^1#f^0#p^1#r^0#I^3#t^H4sIAAAAAAAAAOVYbWwURRi+6wdYoBCDfKO5Lh8Czd7N3t7XLr0zdy3XHpb22rtiaYIwtztblu7tbnfnaC8E0zTQH/wyRgVTJQUBpRqJGmsihh+QqEAC0TTBmGjkh4JCghgNARHd3R7lWgkgvcQm3v64zDvvvPM8z7zvzOyCnillq/rq+q6X26cWDfSAniK7nZoOyqaUVs4sLlpYagN5DvaBnqU9Jb3Fl6p0mJZUthnpqiLryNGdlmSdtYxBIqPJrAJ1UWdlmEY6izk2EV5Xz7qdgFU1BSucIhGOWE2QoL2MNwB55BcA5fMHDKN8J2RSCRIMxQSQJ8BQXh5BgMx+Xc+gmKxjKOMg4QZumqQoEgSSIMACiqUZJ8P42gjHeqTpoiIbLk5AhCy0rDVWy4N6f6RQ15GGjSBEKBaOJhrDsZo1DckqV16sUE6GBIY4o49tVSs8cqyHUgbdfxrd8mYTGY5Duk64QiMzjA3Khu+AeQT4ltJuHnJ0yu3n/bQ35QdCQaSMKloa4vvjMC0iTwqWK4tkLOLsgxQ11EhtRRzOtRqMELEah/nXlIGSKIhICxJrIuEN4XicCNUrGpRltJY01a6GGk/Gm2tIL+MDjDvg95AM9CLoozy5iUai5WQeN1O1IvOiKZruaFBwBBmo0Vht/Kw3TxvDqVFu1MICNhHl+VFgVEN3m7moI6uYwVtkc11R2hDCYTUfvAKjozHWxFQGo9EI4zssiYIEVFWRJ8Z3WrmYS59uPUhswVhlXa6uri5nF+1UtHaXGwDK1bquPsFtQWlImL5mrVv+4oMHkKJFhUPGSF1kcVY1sHQbuWoAkNuJkMcfcINATvexsELjrf8w5HF2ja2IQlUIJwS8bsHr5zlIIUjzhaiQUC5JXSYOlIJZMg21DoRVCXKI5Iw8y6SRJvIs7RXcdEBAJO9jBNLDCAKZ8vI+khIQAgilUhwT+D8VysOmegJxGsKFyfVC5XldhyucVMWmGm80ncDbomomm21l+O6trVCN+cRWpqlyQ0tDa6S1fl3wYavhnuSrJdFQJmnMXxABzFovnAiKjhE/IXoJTlFRXJFELju5FpjW+DjUcDaBJMkwTIhkWFVjBdqrC0XvX24Tj8a7gGfUf3M+3ZOVbqbs5GJljteNAFAVneYJ5OSUtEsxax0a1w/TvMlCPSHeonFznVSsDZIjbEV+5MrpVEy6Tn0b59SQrmQ047btbDRvYEmlA8nGeYY1RZKQtp6acD2n0xkMUxKabIVdgAQX4SQ7bCkfw3ho4GGYCfHirKN002TbkgqyFZdEH+1a7Rr7jh+yWT+q134C9NqPF9ntoAoso5aAiinFLSXFMxbqIkZOEQpOXWyXjXdXDTk7UFaFolY023YdXOznrtQd2d1xu6vzx9U7bPmfGAY2gvmjHxnKiqnpeV8cwOK7PaXUrHnlbpqiQMB4KJppA0vu9pZQc0ueeOf8D9/6Hk/2Lb36B9V08/QscrVcCcpHnez2UltJr93WvGqntOevm4cH9r+3dF5z5YFvfAcWxM7a5Wk8Hb/2/vMzK758+fPKE8NtCwaXHTvs2ds0VO8ePneh/s9Uy8mXEofPzN7d/8vUuoq2Sx/N2He5sv1opHP+qd8ytqp9G6OOIdE7WHZ6cPvK5OWNH19cFA0VLffPGJrzVGzZC5s7axd9ta3z1tO2lc/N+VDrryF2PPb2tWe/bz648Ozy2/wruy7vHLZFil5980nb1CPi2jcGT731euRk7YvSmfN7fr6x6ZBDubET7vrsg4aj1za0n/0Ohucs7r/V8vWhzenbK9CCZ85Frg79uuM4dyUcXjxtbu3w9i9m83s/mZ6o+Gn/inM3X+u78On2g+XxY8W/K++OrOXfFSjt9vwRAAA= cvfv"
    
    private func generateHeaders(for country: EbayCountry) -> HTTPHeaders {
        return [
            "Authorization": "Bearer \(CardsModel.apiKey)",
            "X-EBAY-C-MARKETPLACE-ID": country.rawValue
        ]
    }
    
    // MARK: - Initialization
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
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
    func searchCards(withName name: String, inCountry country: EbayCountry, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
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
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
