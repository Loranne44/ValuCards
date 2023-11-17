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
    static let apiKey = "v^1.1#i^1#p^1#f^0#I^3#r^0#t^H4sIAAAAAAAAAOVYXWwUVRTudreFFQr+EEBCYB2kIZCZvbPb/Zmhu3H7Z7f2f0ttgYp3Z+6UaWdnpjN3aTcNsdTYgBo0JoqGaGoTNQZNFMSIGB6qAj7ICxoFMUFB/MHwACq+YL2zXcq2EkC6iU3cl82ce+653/edc+69M2Cg0Ll6qHrocpFtVv7wABjIt9nYOcBZWLBmnj1/SUEeyHKwDQ/cP+AYtP9UasKEovPNyNQ11USuvoSimnzaGKKShspr0JRNXoUJZPJY4GORulrewwBeNzSsCZpCuaIVIQrGuaAQBAGRBTAusCXEql6N2aKFKI/XE4z7RAF4ggEWkFHTTKKoamKoYjIKPF6aZWk20AKCPPDwPi8T8PjXU65WZJiyphIXBlDhNFg+PdfIQnpjoNA0kYFJECocjVTFGiLRisr6llJ3VqxwRoUYhjhpTn4q10TkaoVKEt14GTPtzceSgoBMk3KHx1eYHJSPXAVzG/DTQvvjrCCyfsnHiggI/txIWaUZCYhvjMOyyCItpV15pGIZp26mKFEj3oUEnHmqJyGiFS7rrykJFVmSkRGiKssi7ZHGRipcqxlQVVENbaldDg2RbmyuoH2cH3CkakpoDvoQ9LMlmYXGo2VknrJSuaaKsiWa6arXcBkiqNFkbQK8L0sb4tSgNhgRCVuIsvxYcFVDlltvJXU8i0m8WbXyihJECFf68eYZmJiNsSHHkxhNRJg6kJaINJWuyyI1dTBdi5ny6TND1GaMdd7t7u3tZXq9jGZ0uj0AsO62utqYsBklIJX2tXrd8pdvPoGW01QERGaaMo9TOsHSR2qVAFA7qXBJIOgBwYzuk2GFp1r/Ycji7J7cEbnqkDgnsVAMQjYO4iLHwVx0SDhTpG4LB4rDFJ2ARjfCugIFRAukzpIJZMgi7/VJHm9QQrTo5yS6hJMkmmx7fpqVEAIIxeMCF/w/NcqtlnoMCQbCOar1HNV5dbc70qLLTRW+qkQMb6nSk6lUGyf2dbVBPeqX27imNe3r6tvK2mrrQrfaDdclX67IRJkWsn5uBLB6PWciaCZG4rToxQRNR42aIgupmZVgryE2QgOnYkhRiGFaJCO6Hs3VXp0jev9ym7g93rk8o/6T8+m6rEyrZGcWK2u+SQJAXWasE4gRtIRbg1avk+uHZd6URj0t3jK5uc4o1oTkOFtZHL9yMhokdBlzi8AYyNSSBrltMw3WDaxF60YqOc+woSkKMlrZafdzIpHEMK6gmdbYOShwGc6ww5YNAEBIsQHvtHgJ6aN000zbknKzFTsqb+ta7Z78ih/OS//YQdsoGLQdyrfZQClYya4A9xXa1znsc5eYMkaMDCXGlDtV8u5qIKYbpXQoG/n35F0GP+4Wfq1+88nuv3p7zq3dmpf9hWG4Ayye+MbgtLNzsj44gKXXRgrY+YuKPF6WJVkPAo/Pux6suDbqYBc6FthefPWBOwr731t55OC3j+wDcw+PLn0dFE042WwFeY5BW16/WnbB+UlN3YNF6LHT9ndG3uY3bGtde2hkuWk/amMbvrqU/+HBA6d7Tvck19q7jlcvv9j89d5LxWO2xzee/WbV4EgJQx9+oyva9Py6E7i6eM6+Bd9f5H555szusu7fD7cPVo10jp46u2/Zxpqtd3223fHcwrH+/i/vHTrnODncWjN0ZYzpdjm+q9+xqHL7F1sTzv11l2Y5f3Ck9j7dPLrrzg3nXwmdk1Jj83bO9+/pFWYdeWve57NHN72288/F7csiT614wb/zTMfKjz+o2c2deL+j8ujP549dfNfVXlf80N0PP3vqyIVHi1/edVw69tsO5mzpyKrV22Zf+ahL6/jD9ynu2bND0U7qLzk3HNj/xHgu/wZTcCqd+xEAAA=="
    
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
