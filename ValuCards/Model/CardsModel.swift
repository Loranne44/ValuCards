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
    static let apiKey = "v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYa2wURRzv9QUFigQJKI9w2WpQmt2b3bve7W16p9eXHIE+uLa0jbTZx2y7dm93uzvb9tQPFbQlamJQo5EiVPhA/IAiTVSiQkD9ICbGD2qQgB9EAiIBJU2FiMHZu1KulUChl9jE/bKZmf/zN//HzIC+/ILV/Wv6/yx0zcoe6gN92S4XPRcU5OcVz8/JXpqXBdIIXEN9D/Xlbs45V2rxcdXgNkDL0DULunvjqmZxyckQYZsap/OWYnEaH4cWh0QuFlm/jmMowBmmjnRRVwl3tCJEiLQMBVYQWcZPgyCg8ax2Q2a9HiJ8JbBE9gt+gWdE3i9LeN2ybBjVLMRrKEQwgPGSIEDSTD3wcz6WAyzFeAMthLsRmpaia5iEAkQ4aS6X5DXTbL29qbxlQRNhIUQ4GqmK1USiFZXV9aWeNFnhMRxiiEe2NXFUrkvQ3cirNry9GitJzcVsUYSWRXjCKQ0ThXKRG8bcg/lJqGlGCgh+KAb5IC0DIGQEyirdjPPo9nY4M4pEyklSDmpIQYk7IYrREJ6CIhobVWMR0Qq386uzeVWRFWiGiMqySHOktpYIr9NNXtPgWtJBu5w3JTJW1kQyQRw6MhsEJCN5AZBEYUxRStoYzJM0leuapDigWe5qHZVBbDWcjI03DRtMVKPVmBEZORal07HjGDItzqamdtFGHZqzrzCOgXAnh3fegXFuhExFsBEclzB5IQlRiOANQ5GIyYvJWBwLn14rRHQgZHAeT09PD9XjpXSz3cMAQHua1q+LiR0wzhOY1sn1FL1yZwZSSboiQsxpKRxKGNiWXhyr2ACtnQj7gC/gBWO4TzQrPHn2XxNpPnsmZkSmMsQv00EvywhMEDJsIAAzkSHhsSD1OHZAgU+Qcd7shMhQeRGSIo4zOw5NReK8JTLjZWVISv6gTPqCskwKJZKfxAUSAggFQQyy/6dEmWqox6BoQpSRWM9YnEtsgi+OM0Gzs8fwN/iquurikhrtri5rr4/YG82KZvXpyi5vj4fuiIammg23dL5cVTAy9Vh/JgBwcj1zIKzRLQSlabkXE3UD1uqqIiZm1gZ7TamWN1GizE7gcQyqKv5Ny9WIYUQzU7Ez5uRdFot78ztzneo/6lK39MpyAndmeeXwW1gAbygU7kNOricoUY97dB4fQpzptqTV7kmEtyTyCHaCarehhbAlEj4HTplJwcWcwi1NmjpLqmFiJ6bOgi8Zki2ie1KU7MwURlNp70DWXensnQ4ogq12Tp1Fgrw6rRBV8FVjRgUo9jTlsiKl7ghU0m/K6hYpE1q6beLrEVXjHJnr9U6o4QMIMnVVhWYjPe3SG4/biBdUONNqcAZqkYJz3XVlhp2QaD8bpH0+H8tOyzcxef5pm2kdJNOd8y5uQp6J7zLhrORHb3Z9Bja7Dma7XCAASLoYPJqf05CbM4+wcO2hLF6TBL2XUniZwmVP45FtQqoTJgxeMbPzXcqJ78QraS9CQ5vAA+NvQgU59Ny0ByKw/OZKHn3fkkLGCwI0A/w+FrAtoOjmai69OHfRsdU5G0Y/bFhVd+yvtk2zW9/ZMeC7DgrHiVyuvCwcvlnFp7/f8uRhteH4a/v7z+8s9c3ZljNn7+OXLtUd7Lq0c+v5+tHdF0e+OTF3uKlZfeXHrbMHzvgXDz4sLny26eehC1uOrmxb+YFxpOvqXuLTs60DF2p7WrYefnn5V0XnTjYeeumt/stf5C4drDv6RMGuXLX51e3vVS55n+KPtuYt23akdlZ4tODUJ0W/n9+9dMHG/Qde9N+/9uKZX46fOvs5jDy4cS3Ys/Dvnx6rCFxua36EeuHL+Irhq2+u+vrbwZGi4dc/Gqka3G2fnHN90fp3Cxb+ussq21HUO4/+uOvQ9ucGtIvD+1pzB5+vXsEu2Kn+BvP2Xa55+xk3/cORa4VvdI/+Edxz4PQ1Yb6+rHtH6UhXXWob/wE4+FnXqxMAAA=="
    
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


// Google Goggle
// Plutot passer par des webService type Google Lens ? Chat Gpt 4 ? Que CoreML

// Nettoyer l'image comme note; mise a plat d'image
