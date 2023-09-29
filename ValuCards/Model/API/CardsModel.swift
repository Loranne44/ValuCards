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
    static let apiKey = "v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYbWwURRjutdeSplQMNaAEwrEVfgC3N7u3d9dd6ZnrtbVXrx9wbW2bNDC3O1u2vdtddud6vR/EpmqjgECINRgUqoJI4geJHzFqIAgxkQjRH2ppIJooSkxjxB8QAT9m70q5VgJIL7GJ9+cy77zzzvM8874zswMGiopXDtUNXS61zckfGQAD+TYbUwKKiwpX3VOQv6gwD2Q52EYGHhywDxZcWGPCeEwX1iFT11QTOfrjMdUU0sZKKmGoggZNxRRUGEemgEUhEmgICywNBN3QsCZqMcoRqq6koFtCPh/Lsh6Z51jEEqt6PWaLRvoBwwE3ywEmikBU9pJ+00ygkGpiqOJKigWs2wl4J8u3AK/gYQWWpRnG00k52pBhKppKXGhA+dNwhfRYIwvrraFC00QGJkEofyhQG2kKhKprGlvWuLJi+Sd0iGCIE+bUVlCTkKMNxhLo1tOYaW8hkhBFZJqUy5+ZYWpQIXAdzF3AT0sty94KDwc5H8P7iNZMTqSs1Yw4xLfGYVkUySmnXQWkYgWnbqcoUSPag0Q80WokIULVDutvbQLGFFlBRiVVUxXoCDQ3U/6wZkBVRfVOS+0gNCRn87pqp4f3Ap6t8HFOHnoQ9DLcxESZaBMyT5spqKmSYolmOho1XIUIajRdGy5LG+LUpDYZARlbiLL9KiY1BJ3WomZWMYE3qta6ojgRwpFu3n4FJkdjbCjRBEaTEaZ3pCUiZaPrikRN70zn4kT69JuV1EaMdcHlSiaTdNJNa0a3iwWAcbU3hCPiRhSHFPG1aj3jr9x+gFNJUxERGWkqAk7pBEs/yVUCQO2m/JyvggUVE7pPheWfbv2HIYuza2pF5KpCJBHKAHlFyEmcJDFiLirEP5GkLgsHisKUMw6NXoT1GBSRUyR5logjQ5EEt0dm3RUyckpeXnZyvCw7ox7J62RkhABC0ajIV/yfCuVOUz2CRAPhnOR6zvK8rtcVaNGVtdWe2ngE99XqiVSqnZf6e9qhHvIq7fzaVR2tje1V7eGGyjuthpuSD8YUokwLmT8XAli1nkMRNBMjaUb0IqKmo2Ytpoip2bXAbkNqhgZORVAsRgwzIhnQ9VBu9uqc0fuX28Td8c7dGfUfnU83ZWVaKTu7WFnjTRIA6gptnUC0qMVdVq1rkFw/LPP6NOoZ8VbIzXVWsSYkM2wVKXPlpNN0abNPpA1kagmD3LbpJusG1qL1IpWcZ9jQYjFktDEzrud4PIFhNIZmW2HnIMEVOMsOW8bLe3gfcHPsjHiJ6aN0/WzbknKxFdsfuctrtWvqR74/L/1jBm2fgEHbkXybDawBy5lysKyooNVeMHeRqWBEK1CmTaVbJd+uBqJ7UUqHipFflncZ/LRHHK87tKX3z+SmHx/anJf9xjDSBe6ffGUoLmBKsp4cwOIbPYXMvIWlrJuQ54HXw7JsJyi/0WtnFtjvO9W7fd2Gut2nz3+8aWjF+IZffeuLO0DppJPNVphnH7Tl1Xz+whtfntjy3qXlXccbpKNzXd+MHr16dbjsjzPNZ7mx0Z1nTw9fPLe7fEew5MxTO1rBh/vDo1/IwrFasNm+5KDv2jPzR5KPvh37653HQo8v2GK8/NyS6J7WBSWrV+wKe06X9nYfW5p8af9H3wZWbz3GL5tnH3/20tDYwLbN56/81lG29/cTQ/Xuw6vGjp+bV6/1lA1X7X+x761xse1C1y947wdV28KfFr1SQHVtOLjLvn3hAz+vLNo6XH2x59ThUNPV0tFl0tL53z/5VefDRvDp4L07Xt35+r7X3j8UeV4/CI4cuOwS4yevtQyU/3Clrq80+O6bSS58ci43Z9/imu8SXx+4opQ9oX/WfoYei2fW8m8xXJh9/REAAA=="
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // MARK: - Initialization
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    // MARK: - SearchCards method by name
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
                    print(responseJSON)
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

// ethernatos Vmax 340

// Vérifier pourquoi appel réseau deuxième fois il y a une erreur
// Comment élargir les retour possible lors du deuxieme appel réseau


// API habituelle  -> API ITEM ()-> API habituelle
