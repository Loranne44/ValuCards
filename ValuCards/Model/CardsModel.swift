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
    static let apiKey = "v^1.1#i^1#f^0#r^0#p^1#I^3#t^H4sIAAAAAAAAAOVYe2wURRjv9a5ggfIQBcJDzy0+It7e7N5jb9femWtL7dU+udIcBULmdmfLcnu7y+4c7WEItaSAxMRo4isoqbwq0mgCf4D4iIjxD4MPhCCC0T+IPIyvxEoTg8Td61GulQDSS2zi/XOZb7755vf7zffNzA7oHFf88MbqjQMltvGFPZ2gs9BmoyaC4nFFCybbC2cXFYAcB1tP5/xOR5f9QpkBk7LGLUKGpioGcnYkZcXgMsYgkdIVToWGZHAKTCKDwzwXDdfVcjQJOE1XscqrMuGMVAYJJCAKBby8QPN+H+v3mFblasxmNUjwcVEUfLyXFWgWQgaY/YaRQhHFwFDBQYIGtMcFWBdgmgHDeX2chyF9AdBKOFuQbkiqYrqQgAhl4HKZsXoO1htDhYaBdGwGIUKRcFW0IRypXFjfXObOiRXK6hDFEKeM4a0KVUDOFiin0I2nMTLeXDTF88gwCHdocIbhQbnwVTC3AT8jtYdHrN/Px2lEs4wnP0pWqXoS4hvDsCyS4BIzrhxSsITTNxPUFCO+CvE426o3Q0QqndZfUwrKkighPUgsLA8vCTc2EqFaVYeKgmpcltgVUBdcjYsqXWY6AZYOMF4XC30I+ilvdqLBaFmVR8xUoSqCZGlmOOtVXI5M1GikNp4cbUynBqVBD4vYQpTrx17VkKFarTUdXMQUXqlYy4qSphDOTPPmKzA0GmNdiqcwGoowsiMjUZCAmiYJxMjOTCpms6fDCBIrMdY4t7u9vZ1s95Cq3uamAaDcsbraKL8SJSFh+Vq1nvGXbj7AJWWo8MgcaUgcTmsmlg4zVU0AShsR8jIBGgSyug+HFRpp/Ychh7N7eEHkq0CoeCDOeBmGFkU/AwMwHxUSyiap28KB4jDtSkI9gbAmQx65eDPPUkmkS4KZVCLtCYjIJfhZ0eVlRdEV9wl+FyUiBBCKx3k28H8qlFtN9SjidYTzk+v5yvPqhDvcrElNlb6qZBSvqdJS6XSMFTpWxaAW8UsxtmnBksX1sfJYbV3wVqvhuuQrZMlUptmcPy8CWLWePxFUAyNhVPSivKqhRlWW+PTYWmCPLjRCHaejSJZNw6hIhjUtkqe9Ol/0/uU2cXu883hG/Tfn03VZGVbKji1W1njDDAA1ibROIJJXk27VqnVoXj8s84oM6lHxlsyL65hibZIcZCsJg1dOUrXoksYantSRoaZ087JNNlg3sGY1gRTzPMO6KstIb6FGXc/JZArDuIzGWmHnIcElOMYOW8rPegFDMx5mVLz4zFG6YqxtSXnZih1Vt3etdg//xg8VZH5Ul+0j0GX7oNBmA2XgfqoU3DfOvthhnzTbkDAiJSiShtSmmJ+uOiITKK1BSS+cXjAAzm/lf6resyVxpX31uUfXFeQ+MfQsB7OGHhmK7dTEnBcHMPdaTxE1ZWYJ7QEsYADj9XmYVlB6rddBzXDcdSb+y5VLd765Ptr/pVw0L/JYb9+WTaBkyMlmKypwdNkKbP37v7lHfujrPqU0mp50Si5ZH3F+/PsJY/qOORMuf5vesLbm187N0Gkf6B/Y/dbO0p7Y9j8SS5fWnnh18pyt7x4/uO7k+XOzpHeelf9ccfmNr5T3L05tnbd62bEjl6bO7z4x0L3h2NwnH3iQmVC55i8ZHSS+2LFhH9h2vOfxp6e9MOP7mQteahKKPr8Yfv2pFw+XnrkktvCek8sQZvbMm7nr3p/PfogujO+fMu1iwXvPFdfVtIWvPLM89PKc0+H0K72fJcoE1Ht40q69J/ed/qH30M47DhxxHKzbK9dNfe3I7lD30R8/7eE3lZ7tm3Wg6dTzTyw9X1P+3d2H1tFdn9j3d+/8bdvbR8nqR/rWbl+0d3At/wZWjkAM/BEAAA=="
    // Grand Central Dispatch pour les différents réseaux (asynchrone)
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        let searchQuery = name.split(separator: " ").joined(separator: "+")
       
        var components = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
            components?.queryItems = [
                URLQueryItem(name: "q", value: searchQuery),
                URLQueryItem(name: "limit", value: "7"),
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

