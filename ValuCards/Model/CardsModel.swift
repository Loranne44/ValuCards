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
    static let apiKey = "v^1.1#i^1#I^3#p^3#r^0#f^0#t^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"
    
    //"https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(encodedSearchKeyword)&filter=category_ids:{183473}&limit=400"
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<Cards2, ErrorCase>) -> Void) {
        let urlString = "https://api.sandbox.ebay.com/buy/browse/v1/item_summary/search?q=\(name)&limit=100"
        guard let url = URL(string: urlString) else {
            completion(.failure(.errorDecode1))
            return
        }
        
        print(url)
        
        task?.cancel()
        session.getRequest(url: url, headers: headers) { result in
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(Cards2.self, from: data)
                    completion(.success(responseJSON))
                } catch {
                    print(error)
                    completion(.failure(.errorDecode))
                }
            case let .failure(error):
                completion(.failure(error))
            }
            
        
        }
    }
}

