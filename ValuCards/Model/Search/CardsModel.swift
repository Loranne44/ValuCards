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
   // private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    // MARK: - API Key & Headers
    static let apiKey = "v^1.1#i^1#p^1#r^0#I^3#f^0#t^H4sIAAAAAAAAAOVYbWwURRi+u16LDbZikI80KMfWKrTZvdmP+9i1d/FoKb3aj4Nr64FAnduba5fu7S67c7RnQtJUhARi1BgTlY8UlESIEonxByQWolHRiCERJcboDw2FRJqYQkqURN29K+VaCSC9xCben8u88847z/PM+87MDhgoKa3e0bjjWpl9jmNoAAw47HZ6LigtKa4pL3JUFNtAnoN9aODRAedg0aVaA6ZkTViLDE1VDOTqT8mKIWSNASKtK4IKDckQFJhChoBFIRpqaRYYCgiarmJVVGXCFa4PEMhLeziOBwD6AcOxyLQqN2K2qwGCpSEPARf3JONxH/LFzX7DSKOwYmCo4ADBAIYlaUDSbDvwChwjsAzl8XvWE65OpBuSqpguFCCCWbhCdqyeh/X2UKFhIB2bQYhgONQQbQuF61e1tte682IFJ3SIYojTxtRWnZpArk4op9HtpzGy3kI0LYrIMAh3MDfD1KBC6AaYe4CflVpk/YD3xX0MEn2+RAIURMoGVU9BfHsclkVKkMmsq4AULOHMnRQ11YhvRiKeaLWaIcL1LutvTRrKUlJCeoBYtTK0LhSJEMFmVYeKgppIS+06qCfIyNp60sN7Ac/4fRzJQw+CXpqbmCgXbULmaTPVqUpCskQzXK0qXolM1Gi6NmyeNqZTm9Kmh5LYQpTv55/UkF5vLWpuFdO4R7HWFaVMIVzZ5p1XYHI0xroUT2M0GWF6R1aiAAE1TUoQ0zuzuTiRPv1GgOjBWBPc7r6+PqqPpVS9280AQLtjLc1RsQelIGH6WrWe85fuPICUslREs4xNfwFnNBNLv5mrJgClmwhyPj8D/BO6T4UVnG79hyGPs3tqRRSqQmjOi2jE+WmO83K031+ICglOJKnbwoHiMEOmoN6LsCZDEZGimWfpFNKlhMB6kgzrTyIy4eWTJMcnk2Tck/CSdBIhgFA8LvL+/1Oh3G2qR5GoI1yQXC9Ynjf2ukPtmrSm3tOQiuKtDVo6k4nxif7NMaiFvVKMX1OzrqM1tjLW3BK422q4Jfk6WTKVaTfnL4QAVq0XUATVwCgxI3pRUdVQRJUlMTO7FpjVExGo40wUybJpmBHJkKaFC7NXF4zev9wm7o134c6o/+h8uiUrw0rZ2cXKGm+YAaAmUdYJRIlqym3VugrN64dl7sqinhFvyby5zirWJskcWymRu3JSWbqUsVWkdGSoad28bVNt1g2sXe1FinmeYV2VZaR30jOu51QqjWFcRrOtsAuQ4BKcZYct7eV9tI9nPcyMeInZo7Rrtm1JhdiKnavv8VrtnvqRH7Rlf/Sg/WMwaB922O2gFlTRlWBZSVGHs+j+CkPCiJJgkjKkbsX8dtUR1YsyGpR0x3zbNXBxj3i58fCu3j/7tow8sc2W/8YwtBEsnnxlKC2i5+Y9OYAlN3uK6QcWlTEsDWgWeDmGZdaDypu9Tnqh86FPPj/ew1SMjS6tpqqWeluq3xoOl4OySSe7vdjmHLTb5B9Pn1q4MbBzxQ7uq2XLvxxeaHj+emo/d/BUoHT3H22j2ztexf794ZqT42OfLu2r7g5WHCk5Uh+bt3nDSPF5+4GfF31UOzT23XObenu2j7/ydeSb40s+uLL314OequELe7mr3OLlZ8+nGz1EzyPS8ye2ldcRz/7SVFM/vr/s6Z/2jcf7Wh/sujL+8oL3Dh87FL3UdXU1+fhRctPpb59p6O54OL77aLVjjzrvRNcCe5A657tv92f8letPdsJN78x/6Yct1IHI2Q1V+vWN77448sXlptbXfcfmHGqq5Hf+prFhrVI81vb92zb7a743L8hvnLS98L7vzIrlzvLREerDM7sei53b13TRMTpWFv09t5Z/A+XOiFv9EQAA"
    
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
