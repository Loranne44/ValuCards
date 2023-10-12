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
    static let apiKey = "v^1.1#i^1#f^0#r^0#I^3#p^1#t^H4sIAAAAAAAAAOVYbWwURRi+6xcCFiQgBVrisUUlkNub3fvcpXd6bak9Utord8WCkTK3O9suvdtddudoD6M01VTAQEiAgKnGEojxA0tiNBJD+CFB+ZSEgOEHogYiYEgkiikBMe7uHeVaCSC9xCben8u88847z/PM+87MDugqGju3p7ZnoNg6Jq+vC3TlWa3UeDC2qHDehPy8GYUWkOVg7eua3VXQnX+5QoOJuMIuRpoiSxqydSbiksaaRj+RVCVWhpqosRJMII3FHBsJLqpjaRKwiipjmZPjhC1U7ScoincJbp9H4DweJwehbpXuxIzKfgLxlNfrRjEqxglumjH6NS2JQpKGoYT9BA1op50CdoqOAoZ1+VhAkxRFLyNsS5CqibKku5CACJhwWXOsmoX1/lChpiEV60GIQChYE2kIhqoX1EcrHFmxAhkdIhjipDa0VSXzyLYExpPo/tNopjcbSXIc0jTCEUjPMDQoG7wD5hHgm1J7PbzPw8cQBTmIEOByImWNrCYgvj8OwyLydsF0ZZGERZx6kKK6GrGViMOZVr0eIlRtM/4akzAuCiJS/cSCyuDSYDhMBOpkFUoSWmg31K6CKm8PL662uxkPYGif12VnoBtBD+XKTJSOlpF52ExVssSLhmiarV7GlUhHjYZr48zSRndqkBrUoIANRFl+FHVHQ+BZZixqehWTuE0y1hUldCFsZvPBKzA4GmNVjCUxGowwvMOUyE9ARRF5YninmYuZ9OnU/EQbxgrrcHR0dJAdTlJWWx00AJSjeVFdhGtDCb3YOhNGraf9xQcPsIsmFQ7pIzWRxSlFx9Kp56oOQGolAi6vjwa+jO5DYQWGW/9hyOLsGFoRuaqQGM8IPMW4IE+73JwnlosKCWSS1GHgQDGYsieg2o6wEoccsnN6niUTSBV51ukWaKdPQHbewwh2FyMI9pib99gpQS9WhGIxjvH9nwrlYVM9gjgV4Zzkes7yvLbdEYwqYmO1uyYRwatrlGQq1czwnSuboRLyiM1M47ylTfXNlc11i/wPWw33JF8VF3Vlovr8uRDAqPUciiBrGPEjohfhZAWF5bjIpUbXAjtVPgxVnIqgeFw3jIhkUFFCudmrc0bvX24Tj8Y7d2fUf3Q+3ZOVZqTs6GJljNf0AFARSeMEIjk54TBqXYb69cMwt5ioR8Rb1G+uo4q1TjLNVuTTV07SpEtqqzlSRZqcVPXbNtlg3MCicjuS9PMMq3I8jtQl1IjrOZFIYhiLo9FW2DlIcBGOssOW8jBeCriAjx4RL848SltG25aUi6244IVHvFY7hn7kByzmj+q2fgW6rQfyrFZQAZ6mysGsovymgvzHZ2giRqQIBVITWyX921VFZDtKKVBU8yZbBsClXu5q7Ycb2v/qWPXz/Fct2W8MfS+DaYOvDGPzqfFZTw6g7G5PITWxpJh2UoCiAePyAXoZKL/bW0BNLZgyZtrB51wVx6aUnd/6wfhdfy4//cfRECgedLJaCy0F3VbLuDn1Dbev3CzHt7/RPindIe7a0Lv+YIml/6f515+fsGZy6dR3Dz5/yLr7M7d05ETvpS9mdm2dcG722psnnmkrphufPbxmz5u/XJ//cfkRtuHW5W9rj/248uuWV7Zt3H7l9Ipfb0RQtHwis+27kv6eF5uK1FXVZ3Dj7MtvdYMzYveWs0/u2/N6/7nlj/ku3CBbZ/Ur2y9eEJvKHMfPr9u3dty+6banxm2ehL/87f1ptza9vYqbsv610ncOX9x8be/Jyunh97a7tu78dMvne04Gd790pnhDeNsbO6+d4sAT3/ftKFnIVnhPBeaGXIcHSn/I2xQ8O3P/7z1lV/YenzrQ4nHPWXFg/0e3e49e3Tjp6KF1J9Jr+TdT2e08/REAAA=="
    
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
        
        //    task?.cancel()
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
        
        let searchQuery = name.split(separator: " ").joined(separator: "+")
       
        let headers = generateHeaders(for: country)
       
        performRequest(with: componentsForSearch(query: searchQuery), headers: headers) { result in
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
