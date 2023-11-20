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
    static let apiKey = "v^1.1#i^1#p^1#f^0#I^3#r^0#t^H4sIAAAAAAAAAOVYa2wUVRTebbcl2OVNEAnRdYo2UGf2zkz3NXQ32b7chT6W7tIsVR53Z+7A0HkxD9oFg7XBJqJRCaCGRgMN8UUUMRh/qFVICGo04h/TqMRoICE+CQlBQYMz26VsKwGkm9jE/bOZc8899/u+e869Zwb0lk9d0h/rvzjNOaVkXy/oLXE6yQowtbysenppyYIyByhwcO7rXdTr6is9W6tDSVSZdqSriqwjT48kyjqTM4YxU5MZBeqCzshQQjpjsEwy2tLMUARgVE0xFFYRMU+8IYwFORKRJM/SPo7j/DSwrPLVmCkljPG8L0ijEEWHMiTPs9awrpsoLusGlI0wRgGKxkkSp0AKBBlAMYAmgI/uxDwdSNMFRbZcCIBFcmiZ3FytAOqNkUJdR5phBcEi8WhTsi0ab2hsTdV6C2JF8jIkDWiY+tineoVDng4omujGy+g5byZpsizSdcwbGVlhbFAmehXMbcDPKe0HJERB0hfkKYrm6VBRpGxSNAkaN8ZhWwQO53OuDJINwcjeTFFLjcxGxBr5p1YrRLzBY/+tMKEo8ALSwlhjXXRVNJHAIs2KBmUZLcNtteuhxuGJ9gbcF/KDEBUM1OAh6EPQT9bkFxqJlpd53Er1iswJtmi6p1Ux6pCFGo3VJsD4CrSxnNrkNi3KGzaiAj8SXNWwJthpb+rILprGBtneVyRZQnhyjzffgdHZhqEJGdNAoxHGD+QkCmNQVQUOGz+Yy8V8+vToYWyDYaiM19vd3U1004SirfdSAJDedEtzkt2AJIjZvnat5/yFm0/AhRwVFlkzdYExsqqFpcfKVQuAvB6L1ASCFAjmdR8LKzLe+g9DAWfv2IooVoX4SIoL8TRFcwHg8/OoGBUSySep18aBMjCLS1DrQoYqQhbhrJVnpoQ0gWNoH0/RQR7hnD/E4zUhnsczPs6PkzxCAKFMhg0F/0+FcqupnkSshozi5Hqx8jzW5Y2mVGFFg69JShqbm1Qzm02HuJ6NaajG/UI6tKJ61crWdF26uSV8q9VwXfL1omApk7LWL4oAdq0XTwRFNxA3IXpJVlFRQhEFNju5NpjWuATUjGwSiaJlmBDJqKrGi3RWF4vevzwmbo93Ee+o/+Z+ui4r3U7ZycXKnq9bAaAqEPYNRLCK5FXsWodW+2Gb1+ZQT4i3YHWuk4q1RXKErcCNtJyEYtMl9M0soSFdMTWr2yba7A4spXQh2brPDE0RRaR1kBOuZ0kyDZgR0WQr7CIkuAAn2WVLBgCo8Qestm1CvNjcVbp2sh1JRTmKXU2311Z7x77jRxy5H9nnPAb6nEMlTieoBfeRleDe8tKVrlL3Al0wECFAntCF9bL17qohogtlVShoJXMc5wf3xOoXNLY9t2RrKnty4ITDXfCJYd9qMH/0I8PUUrKi4IsDWHhtpIyccec0iiZJS8UgoADdCSqvjbrIea65Ve+6RPHoObh7485nS6veWfPoul9eAdNGnZzOMoerz+mA2zZF2o8x7zvK9h//1bk12lz7WHnDrm3bP1w8r8JLHPh58dfv/f4mOVjBnIw9Nben85Gt3JJEX9UXP/3p6r/7qysnWvY23nNqx/aFzyz8Zv6RyvmBtHT2/JYnnl6WPLJ93tBd7siXdZm9hPQHBfbcMfDxiwdDq2etbdzlfrx63cE3hl3OyMCF7/aj4SvDy3fM/uCldeZgc8fDPz4/9LZDqu4dDC29WPV5ydmh3TufnC4ol9acRi8MuBeZRxNXpmAz3jr+2fLYgdpjkTP3n+uKzUrNPONqef2jT3u+VYZfbXecdiN45nBHJup+aM5l8lLswqFPXvtt5sCmH14+1P/95QfVxQ+0JLYsnf3X4VMrR/byb7/jdY/8EQAA"
    
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
                    print("JSON Decoding Error: \(error)")
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
