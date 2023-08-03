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
    static let apiKey = "v^1.1#i^1#f^0#p^1#I^3#r^0#t^H4sIAAAAAAAAAOVYe2wURRi/64sQXjESKK96rhgU3L3ZvUd317uL15bSI31ypTma1jK7NwtLbx/uztG7GEytWhWJBkmIColVVAQ1gAj+ISGKkCjGP4j4SECUxEBFEnwQ+KMJuLst5VoJIL3EJt4/l/nmm29+v99838zsgO6SiQt7a3ovT3FPKOjrBt0Fbjc9CUwsKV40tbBgdrEL5Di4+7rndxf1FPaHTKikdH4ZMnVNNZEno6RUk3eMYSJtqLwGTdnkVaggk8ciH4/W1fIMBXjd0LAmainCE6sKE/5yIEgc6xdFiRbZcmhZ1Wsxm7UwIQRpWkJcgAsyAb8f2P2mmUYx1cRQxWGCAYyPBCwJfM2A42mG9wUpAAKthKcFGaasqZYLBYiIA5d3xho5WG8OFZomMrAVhIjEotXxhmisanF9c8ibEysypEMcQ5w2R7YqtSTytMBUGt18GtPx5uNpUUSmSXgjgzOMDMpHr4G5A/iO1IKfAxIjiT6WCbJ+5MuLlNWaoUB8cxy2RU6SkuPKIxXLOHsrRS01hDVIxEOteitErMpj/zWlYUqWZGSEicUV0RXRxkYiUqsZUFXRUtJWuxIaSbJxWRVpJQ3gGLbcT3IwgGCQ9g9NNBhtSOZRM1VqalK2RTM99RquQBZqNFobkKON5dSgNhhRCduIcvxo2tEwQHEc12ov6uAqpvFq1V5XpFhCeJzmrVdgeDTGhiykMRqOMLrDkShMQF2Xk8ToTicXh9InY4aJ1RjrvNfb1dVFdfkozVjlZQCgvYm62ri4GilWsWUUu9YH/eVbDyBlh4qIrJGmzOOsbmHJWLlqAVBXERF/OcsAdkj3kbAio63/MORw9o6siHxVCGPtQpwkoAArsSIQ8lIhkaEk9do4kACzpAKNToT1FBQRKVp5llaQISetTJEYHyshMhnkJNLPSRIpBJJB0tr+EEBIEESO/T8Vyu2mehyJBsJ5yfW85XlNpzfarMtNVYFqJY7XVuvpbDbBJTNrElCPBeUE17RoxfL6REWiti58u9VwQ/KVKdlSptmaPx8C2LWeRxE0E6PkmOjFRU1HjVpKFrPja4F9RrIRGjgbR6mUZRgTyaiux/KzV+eN3r/cJu6Md/7OqP/ofLohK9NO2fHFyh5vWgGgLlP2CUSJmuK1a12D1vXDNnc4qMfEW7ZuruOKtUVykK2cHLxyUg5dylwrUgYytbRh3bapBvsG1qx1ItU6z7ChpVLIaKHHXM+KksZQSKHxVth5SHAZjrPDlg5yNAj4uEBgTLxE5yjtGG9bUj624qIld3it9o78yI+4nB/d4z4EetwHC9xuEAL30/eBe0sKlxcVTp5tyhhRMpQoU16lWt+uBqI6UVaHslFwt+syOLtFPF+zY33nla7Hzjy8zpX7xtDXDkqHXxkmFtKTcp4cwNzrPcX0tJlTGB9ggQ9wNOMLtoL7rvcW0TOKppd27B6YfC6+4+oXd73fdvTdkH/eqR4wZdjJ7S52FfW4XQVzTv/xyLYj7S19C76vU155pn/gnjkftPxytMSz8tjGp658PrBTD396JtCxvu2NnQf39G/a2b2u5qXnjl89Ul/6hNo04/jbv1ZcvcwuOzXz6N4t28wLr/rVvadLn+xtPwzA8nMvPr0dlq2ZulV5+bXfynazm9+JqA8s3UwVLXHNQuXvnQz91Jqoa4x/9t2O2eKm3/Wviqv3P3jgwNzkpv4L7dl55/764fV1icDWC5v3w+ijuw4JG84GqB8Pn+jr+3j+ktCe7ecvfRj69khqIRQgs7JXxCfPfjPBu4D8RF9/+OLFS1H68X2z3uyc/vWzlzbsy+x9vuzPL9/aeGKgrcyVcf/80QuTj+2a5npILmgbXMu/AfJSVpT9EQAA"
    
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        
        let urlString = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=pikachu&limit=3"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.errorDecode))
            return
        }
        
        print(url)
        
        task?.cancel()
        
        session.getRequest(url: url, headers: headers) { result in
            
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
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


// Google Goggle
// Plutot passer par des webService type Google Lens ? Chat Gpt 4 ? Que CoreML

// Nettoyer l'image comme note; mise a plat d'image

