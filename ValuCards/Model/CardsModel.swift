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
    static let apiKey = "v^1.1#i^1#I^3#f^0#p^1#r^0#t^H4sIAAAAAAAAAOVYa2wUVRTe7TOllgZEqA3iOqWGQGb3zu7sdmfa3WTpAxb63oUUAmnuztxph92dGefO0m5ErMXUCDaKiD8sEUyMz4iiUX8okEAElUTQagw+ECM+fjRKjIEIAb2zu5RtJYB0E5u4fzZz7rnnft93zrn3zoCBopLFQ8uHzpdZi/P2DICBPKuVKQUlRYVLZubnVRZaQJaDdc/AwoGCwfxf6jCMxzS+E2FNVTCy9cdjCuZTRh+V0BVehVjGvALjCPOGwIcCLc280w54TVcNVVBjlC3Y4KOgywUZIDlZUeK4GugmVuVKzLDqo5wAIVFyswLLshHJLZFxjBMoqGADKoY57nTRgKOBO8w4edbNs4zdCzxrKdtqpGNZVYiLHVD+FFw+NVfPwnp9qBBjpBskCOUPBppCbYFgQ2NruM6RFcuf0SFkQCOBJz7VqyKyrYaxBLr+MjjlzYcSgoAwphz+9AoTg/KBK2BuAX5KapGLiF7BzUmMS/K6vK6cSNmk6nFoXB+HaZFFWkq58kgxZCN5I0WJGpENSDAyT60kRLDBZv51JGBMlmSk+6jGpYE1gfZ2yt+s6lBR0AraVLse6iLd3tlAuzkP4JzeGpbmoBtBD8NmFkpHy8g8aaV6VRFlUzRsa1WNpYigRpO1cWVpQ5zalDY9IBkmomw/dlxD11ozqeksJoxexcwrihMhbKnHG2dgfLZh6HIkYaDxCJMHUhKRttI0WaQmD6ZqMVM+/dhH9RqGxjscfX199j6XXdV7HE4AGEdXS3NI6EVxSBFfs9fT/vKNJ9ByioqAyEws80ZSI1j6Sa0SAEoP5WdrvE7gzeg+EZZ/svUfhizOjokdkasOgRzrlZAbckioIftSTS46xJ8pUoeJA0Vgko5DPYoMLQYFRAukzhJxpMsiKSrJ6SLL06KHk2iWkyQ64hY9NCMhRDbBSETgvP+nRrnZUg8hQUdGTmo9Z3W+POoIhDW5o8HdFA8ZG5u0RDLZxYn9G7qgFvTIXVzHkjWrWruWdjW3+G62G65Jvj4mE2XCZP1cCGD2eg5FULGBxCnRCwmqhtrVmCwkp1eCXbrYDnUjGUKxGDFMiWRA04K52atzRu9fbhO3xjt3Z9R/dD5dkxU2S3Z6sTLnYxIAarLdPIHsghp3mL2uQnL9MM3dKdRT4i2Tm+u0Yk1IptnKYvrKaU/RteONgl1HWE3o5LZtbzNvYGE1ihRynhm6GoshfTUz5X6OxxMGjMTQdGvsHBS4DKfZYct4OBfH1HDs1NImpI7S7um2JeViKy5YdovXasfEl3y/JfVjBq2HwKD1QJ7VCupANVMF7inKX1WQf1sllg1kl6Fkx3KPQt5ddWSPoqQGZT3vdst58POIMLb85a3Ry333/VT7gCX7G8Oe9aBi/CtDST5TmvXJAcy/OlLIlM8rc7oAB9yMk3WzzFpQdXW0gJlbMKezevjOJw937x0ePL5j3a9vVcXBjyFQNu5ktRZaCgatlkUfnmqIzmp8tLjs9FBl24GHthVSG146V5xoclzwn+377UTPnKF33zn34khd1evlT1d+8ZVn2SMHdn+wdaD20MULC8rvEHwPV/aCoYXe2sW8d9+Y5+CnR/ef/ahu0ecHT4dHPqYjj3+zad7zx7Y6vh3bqW9ZsKRED3aURunkWGPyTO0P3VtGW0KjI7vepz37d3y98Mu3576Wf3j2yd16+bN3HXtiO5456/v7732ulV9Xkec4NuPUC5vBZ6OvXLg045PNM+a/uX39kd/vht/hSyPP4L27lh2nbU/9efJc7EjPX0WW0f3b/phzouJM9fCqlbbHdpbWr3xjtLP68s6jw80XmX1NDxasmJ+seHVT8XtDs9O5/BvaYFHV/REAAA=="
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

