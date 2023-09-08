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
    static let apiKey = "v^1.1#i^1#f^0#p^1#r^0#I^3#t^H4sIAAAAAAAAAOVYe2wURRi/6wMshcMHUUTRcwu+YO9m95679E6uPQrXtL3CXbE0apnbnW2X3j7cneN6CcZSFRNRI6AEQySA8YEEEsFEognGByrxlSCJxEDwD0ESaiT4BwmicfbuKNdKAOklNvGSzWW++eab3+833zczu2BgQs2DaxatOTfFPrFi6wAYqLDbmVpQM6F6jqOyYka1DZQ42LcOzBqoGqw8VW9CJa3zS5Cpa6qJnP1KWjX5vDFEZQyV16Apm7wKFWTyWOATkdYWnnUBXjc0rAlamnLGoiEqwEBWYhnGG/AFA14AiVW9GDOphaig6BPFAAAMl0p52IBE+k0zg2KqiaGKQxQLWA8NOBoEkwzgvT7eF3ABL+iinEuRYcqaSlxcgArn4fL5sUYJ1itDhaaJDEyCUOFYpCkRj8SiC9qS9e6SWOGiDgkMccYc2WrURORcCtMZdOVpzLw3n8gIAjJNyh0uzDAyKB+5COY64Oel9npSnNfnQ35fkAmmOKYsUjZphgLxlXFYFlmkpbwrj1Qs49zVFCVqpFYgARdbbSRELOq0/hZnYFqWZGSEqAUNkWWR9nYq3KIZUFVRM22p3QgNkW5fEqV9nB9wLEkrmoM+BP2MtzhRIVpR5lEzNWqqKFuimc42DTcgghqN1sZTog1xiqtxIyJhC1GpH3tRQ0+gy1rUwipmcK9qrStSiBDOfPPqKzA8GmNDTmUwGo4wuiMvUYiCui6L1OjOfC4W06ffDFG9GOu8253NZl1Zj0szetwsqTR3Z2tLQuhFCinGfsWq9YK/fPUBtJynIiAy0pR5nNMJln6SqwSA2kOFvYEgC4JF3UfCCo+2/sNQwtk9siLKVSGsR0B+P+uBCEDOz6ByVEi4mKRuCwdKwRytQKMPYT0NBUQLJM8yCjJkkSSVxHqCEqJFPyfRXk6S6JRP9NOMhBBAKJUSuOD/qVCuNdUTSDAQLkuuly3PF/W5I0ldXhz1NSkJvLJJz+RynZzYv6IT6jG/3MktnrOso62zobOlNXSt1XBZ8o1pmSiTJPOXQwCr1ssogmZiJI6JXkLQdNSupWUhN74W2GOI7dDAuQRKp4lhTCQjuh4rz15dNnr/cpu4Pt7lO6P+o/PpsqxMK2XHFytrvEkCQF12WSeQS9AUt1XrGiTXD8vcnUc9Jt4yubmOK9aEZIGtLBaunK48XZe5UnAZyNQyBrltu+LWDSyp9SGVnGfY0NJpZCxlxlzPipLBMJVG462wy5DgMhxnhy3j57zk4XyBMfES8kdp93jbksqxFVctvM5rtXvkS37Ylv8xg/ZPwKB9f4XdDurBbKYO3DOhsqOqcvIMU8bIJUPJZco9Knl3NZCrD+V0KBsVt9jOgV82C0OLdjzX91f28ZPznrCVfmPY+iiYPvyVoaaSqS355ADuvNRTzUy9bQrrARwIMoC8zQa6QN2l3irm1qppN4RXLf/y4c+7JzXLx7vWzvitbvdaAKYMO9nt1baqQbstFHhyds9Lz8x/5czJLau7Jz1yatubR75b35z9Yleqdog+quypPnLohGPj4Yo+evKGY3fcf+ibidLB7efp3+uiLW899vPsmyKVO590rIof2pgd3PLA3p796bmR485NPau/Hdg59MdTHeun6nPvntP80Kutjt4lP1C7D2y+PRLJnnG8uybpuLB8X8c6JLq7n8WHd3HOaWfbZ324byPTtfenA7s+nbnavyM+uPvFzImD79Nn/zzX+9kbC389L254vmae1FE7ve3m+UOzQMNdDgyPrft+7un6F7a/3PLB/o8aL9y7/OMb39m3Rw55wIH6t22t9x1Vnv4qui34dQPahDLr6uOrXmcr35Pn/TjztP81UFjLvwHpaCJU/REAAA=="
    // Grand Central Dispatch pour les différents réseaux (asynchrone)
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        let searchQuery = name.split(separator: " ").joined(separator: "+")
       
        var components = URLComponents(string: "https://api.ebay.com/buy/browse/v1/item_summary/search")
            components?.queryItems = [
                URLQueryItem(name: "q", value: searchQuery),
                URLQueryItem(name: "limit", value: "200"),
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

