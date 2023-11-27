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
    static let apiKey = "v^1.1#i^1#p^1#I^3#r^0#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTuPopWxIIiYhWyDoJEnNk7O7uzs0N347aldG27LexSlyKPOzN32qG7M8PMXdolEpuKqA0CkpSokAaMSDA+CT+NP2owKYlGkRg1gcQQwRDfkjREQ5zZLmVbCSDdxCbun82ce+653/fdc+49M6B3WsWj2xu2j8xw3OY80At6nQ4HPR1UTCtfcpfLWVVeBoocHAd6H+5197l+qDZhJq3zK5Gpa6qJPD2ZtGryeWOYyBoqr0FTMXkVZpDJY5FPRJubeB8FeN3QsCZqacITqwsTHGJYwAKGpUWGDgohy6peiZnUwoQcCLBIDkBRQoI/wAatcdPMophqYqjiMOEDPoakadIXTIIQ72d5GlAgyLUTnjZkmIqmWi4UICJ5uHx+rlGE9fpQoWkiA1tBiEgsWp9oicbqlsWT1d6iWJGCDgkMcdYc/1SrScjTBtNZdP1lzLw3n8iKIjJNwhsZXWF8UD56BcwtwM9LLUBOQlxA5gBEnCCikkhZrxkZiK+Pw7YoEinnXXmkYgXnbqSopYawEYm48BS3QsTqPPbfiixMK7KCjDCxrCa6OtraSkSaNAOqKnqCtNWuhYZEtq6sIwMhFoR8XNBPhmAAQZb2FxYajVaQecJKtZoqKbZopieu4RpkoUYTtWGKtLGcWtQWIypjG1GRH02Paehvtzd1dBezuFO19xVlLCE8+ccb78DYbIwNRchiNBZh4kBeojABdV2RiImD+VwspE+PGSY6MdZ5r7e7u5vqZijN6PD6AKC9qeamhNiJMpCwfO1aH/VXbjyBVPJU7Nyy/Hmc0y0sPVauWgDUDiLiD3I+wBV0Hw8rMtH6D0MRZ+/4iihVhciBIOAYv8DJNMsBv1yKCokUktRr40ACzJEZaHQhrKehiEjRyrNsBhmKxDMB2cdwMiIlNiST/pAsk0JAYklaRgggJAhiiPs/FcrNpnoCiQbCJcn1kuV5Q5c3mtSVFXWB+kwCb67Xs7lcKiT1bExBPcYqqdCKJatXxVM1qabm8M1WwzXJ16YVS5mktX4pBLBrvYQiaCZG0qToJURNR61aWhFzU2uDGUNqhQbOJVA6bRkmRTKq67HSnNUlo/cvj4lb4126O+o/up+uycq0U3ZqsbLnm1YAqCuUfQNRopbx2rWuQav9sM3r86gnxVuxOtcpxdoiOcpWkUZbTipPlzI3i5SBTC1rWN021WJ3YEmtC6nWfYYNLZ1GRhs96XrOZLIYCmk01Qq7BAmuwCl22dJBQFstBhMEk+Il5q/S9VPtSCrFUexefotttXf8S36kLP+j+xxDoM/xkdPhANVgIb0APDTNtcrturPKVDCiFChTptKhWu+uBqK6UE6HiuG8p2wEnN8n/thwpL/rcvemc0u3lhV/YziwFswd+8pQ4aKnF31yAA9eHSmnK++b4WNo2hcEIT9Lg3aw4Oqom57jnv3F4tcvfrtNv+PE4b+4iuHzx09mNrjAjDEnh6O8zN3nKIu8fHTt+/cONXbEG+5+81XmyXWBjw92OHuOkj2uQw3OY4vFz9eYm2v730v6dy4a3DtQs/vMG8+JAxfOnc1pz7gXx6vpP99e2vjVO79JlbXL9w+/FHr+g86dWzYKg9zCUxsW+V488mw1vf/x0/M+/GSI8IZmz38X//6YIjb+kWJ2n9jUNX/+N3NCSemF+CXz8j5j1+HX2hqeHlwz69jen2ee/OXCvmODuaqntn7thzucey5t2X3ufvDrA+wIVfVl6qe3mLX9S9bt+LR5nnjqFXjGN2/bgHpaKB+IzuwfnskNXKD2iMfJz2ZdPvQ9f3Bk5yPCmYuJYWrDCXj7UPt3W4m5jWd3RY9XGiuXrRndy78BGtbCVf0RAAA="
    
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
