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
    static let apiKey = "v^1.1#i^1#f^0#r^0#I^3#p^1#t^H4sIAAAAAAAAAOVYW2wUVRje3W5raqkI5RYuugxWtDizZ/YyuzOwm2y7rF0o28supUCgOTtzph26OzOdOdt2pcSmKoFCeFCCiZhQIVGJD8YYEIlcYtTEIBpDACPeQpRyizzwwJs4sy1lWwkg3cQm7svm/Oc///m+7/z/OWcO6Csprdpau/VWufUx22Af6LNZrXQZKC0pXvJEkW1usQXkOVgH+57ps/cXXV6mw3RK5ZqQriqyjhw96ZSsczljgMhoMqdAXdI5GaaRzmGei4dW1XEuCnCqpmCFV1KEIxoOECzPMkko+Lx+gfW4WWhY5TsxE0qA8CZ5j4thfC6RFwXWzxj9up5BUVnHUMYBwgVcbhKwJKATgOE8Pg64KRdDryMczUjTJUU2XChABHNwudxYLQ/r/aFCXUcaNoIQwWgoEq8PRcPLY4llzrxYwREd4hjijD62VaMIyNEMUxl0/2n0nDcXz/A80nXCGRyeYWxQLnQHzCPAz0mNoOj1Mz4/LyaB2+MriJIRRUtDfH8YpkUSSDHnyiEZSzj7IEENMZKbEI9HWjEjRDTsMP8aMzAliRLSAsTy6tDaUEMDEaxTNCjLaAVpil0DNYFsaAqTXpYBrMvv85As9CLI0J6RiYajjag8bqYaRRYkUzPdEVNwNTJQo/HauPO0MZzq5XotJGITUb6f/46GXmaduabDi5jB7bK5rChtCOHINR+8AqOjMdakZAaj0QjjO3ISBQioqpJAjO/MpeJI9vToAaIdY5VzOru7u6luN6VobU4XALSzZVVdnG9HaaMWDV+z1nP+0oMHkFKOCo+MkbrE4axqYOkxUtUAILcRQY/P7wL+Ed3HwgqOt/7DkMfZObYgClUgLp4GPAvFJM0nWRcNC1EhwZEkdZo4UBJmyTTUOhBWU5BHJG/kWSaNNEng3F7R5faLiBQYViQ9rCiSSa/AkLSIEEAomeRZ//+pUB421eOI1xAuTK4XKs9rO5yhhCo1hr2RdBx3RdRMNtvCCj2bWqAaZaQWtnHJ2tWxluqWulWBh62Ge5KvSUmGMglj/oIIYNZ64URQdIyECdGL84qKGpSUxGcn1wK7NaEBajgbR6mUYZgQyZCqRgu0VxeK3r/cJh6NdwHPqP/mfLonK91M2cnFyhyvGwGgKlHmCUTxStqpmLUOjeuHaW7NoZ4Qb8m4uE4q1gbJYbaSMHzlpBSTLqV38ZSGdCWjGZdtqt68gSWUDiQb5xnWlFQKac30hOs5nc5gmEyhyVbYBUhwCU6yw5ZmWLfXC/wu94R48bmjtHWybUkF2YrtkUe7VjvHfuMHLbkf3W/9HPRbj9usVrAMVNKLwMKSotX2oilzdQkjSoIipUttsvHpqiGqA2VVKGm2CsstMLSXv157cKDjr+7OS0u3WPKfGAY3gDmjjwylRXRZ3osDmH+3p5ieOrvc5QYsoAHj8QH3OrDobq+dnmWfQX24Ztvl7h++nv9B6YmhlQMzor3uK6B81MlqLbbY+62WaEnj0Tnr9yxIvPf7H22P98Zi4Y7IR5fqKn89WzMlsnFW1Ttb1oP9O2/aDn2MZlS+eyCxy97z2c6yuT9X0699sr13oOzq7rcWb9l3unfmqTPPTvv2y+5O+Gmi9eKN089t3nF2TaXtm+tg74+l579/+fmqfdP3H3nynHBu3lPT5BvzmosHtq3pWpE9YV/ciUsXzHx/QfjSqZ8OO6aeudZ0qOnNjdpWZEmmbq/svHBx1mKwp7Ni14WnpxSdO3+1OD7w29RrtUO3dlTdXHpy4frpPYPlu1+o2HDy8DXnK9Zjxb1/Rlq/upJ4e/Z3m5saem+/+NJRYsmhV4deZ7sqjmTfiB385cwXxxzhZPuBvce9fQd6h9fyb7fakCP8EQAA"
    // Grand Central Dispatch pour les différents réseaux (asynchrone)
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<ItemSearchResult, ErrorCase>) -> Void) {
        let searchQuery = name.split(separator: " ").joined(separator: "+")
        let urlString = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(searchQuery)&limit=8&category_ids=2536"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.errorDecode))
            return
        }
        
        task?.cancel()
        
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

