//
//  ValuCardsService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation
import Alamofire

class PokemonCardsModel {
    // Remplacez 'YOUR_API_KEY' par votre clé d'API eBay
    private let apiKey = "YOUR_API_KEY"
    
    func searchPokemonCards(searchKeyword: String, completion: @escaping ([Card]?, Error?) -> Void) {
        guard let encodedSearchKeyword = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(nil, NSError(domain: "EncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Impossible d'encoder le terme de recherche"]))
            return
        }
        
        let urlString = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(encodedSearchKeyword)&filter=category_ids:{183473}&limit=400"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL invalide"]))
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(apiKey)"]
        
        AF.request(url, headers: headers)
            .validate()
            .responseDecodable(of: [Card].self) { response in
                switch response.result {
                case .success(let cards):
                    completion(cards, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}

