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
    // Provides a single shared instance of CardsModel throughout the application
    static let shared = CardsModel()
    
    // MARK: - Properties
    private var task: DataRequest?
    private let session : CardsProviderProtocol
    
    // The eBay API key
    static let apiKey = "v^1.1#i^1#f^0#p^1#r^0#I^3#t^H4sIAAAAAAAAAOVYa2wUVRTebbclFSsqKoigy1QjWGfmzuxzxu6abZfK0nd3adoaIPO42w7deThzt9sNEJuaQCHEKD6RhNaoTYoxQaMREkSlKolKQowPiPpLeZiABFAJ/ABndpeyrQSQbmIT989mzj333O/7zjn33hnQX1r2yPql68+V22cUDfeD/iK7nZoJykpLKm8rLppXYgN5Dvbh/gf7HQPFx6sMTk5obCs0NFUxoLNPTigGmzEGsKSusCpnSAarcDI0WCSw0VBDPUsTgNV0FamCmsCckXAAowDH+OMexu3384Kb8ZlW5XLMmBrAPAwPGBdDuzyiP86IgjluGEkYUQzEKSiA0YB24YDBKTpG0SztYWk/4Qe+TszZBnVDUhXThQBYMAOXzczV87BeGypnGFBHZhAsGAnVRptCkfCSxlgVmRcrmNMhijiUNCY+1agidLZxiSS89jJGxpuNJgUBGgZGBrMrTAzKhi6DuQn4GandPOXmedEn+AXK4xGZgkhZq+oyh66Nw7JIIh7PuLJQQRJKX09RUw1+NRRQ7qnRDBEJO62/liSXkOIS1APYkupQR6i5GQvWqzqnKHAZbqldw+ki3twaxj2MFzC03+fGGc4DOS/lzi2UjZaTedJKNaoiSpZohrNRRdXQRA0na0PlaWM6NSlNeiiOLET5fu6chj6G6bSSms1iEnUrVl6hbArhzDxePwPjsxHSJT6J4HiEyQMZiQIYp2mSiE0ezNRirnz6jADWjZDGkmQqlSJSLkLVu0gaAIpsb6iPCt1Q5jDT1+r1rL90/Qm4lKEiQHOmIbEorZlY+sxaNQEoXVjQ7fPTwJ/TfSKs4GTrPwx5nMmJHVGoDhEo3gsEFxXnGZ5z+X2F6JBgrkhJCwfkuTQuc3oPRFqCEyAumHWWlKEuiazLE6dd/jjERS8Tx91MPI7zHtGLU3EIAYQ8LzD+/1Oj3GipR6GgQ1SQWi9YnS/tIUMxTWoJe2rlKOqt1ZLpdDsj9q1u57SIV2pnWio7lje2V7fXNwRutBuuSr4mIZnKxMz1CyGA1esFFEE1EBSnRC8qqBpsVhOSkJ5eCXbpYjOno3QUJhKmYUokQ5oWKcxeXTB6/3KbuDnehTuj/qPz6aqsDKtkpxcra75hBuA0ibBOIEJQZdLqdZUzrx+WeVUG9ZR4S+bNdVqxNklm2Upi9spJZOgSRq9A6NBQk7p52yaarBtYTO2BinmeIV1NJKDeRk25n2U5iTg+AadbYxegwCVumh22lJdxe2jKQ0+Nl5A5SldNty2pEFux44mbvFaTE1/yg7bMjxqw7wMD9r1FdjuoAg9RFWBhafFyR/Gt8wwJQULi4oQhdSnmu6sOiR6Y1jhJL5ptOweObRNOLB3d1HMx9dTRx9bZ8r8xDK8Ac8e/MpQVUzPzPjmA+VdGSqhZc8ppF2AomqJpM+edoOLKqIO6x3FX6Q73os2BDdT8ysG/Bt948dWKrvUrQPm4k91eYnMM2G2NP793y+1Hz75bHDm0ZvElIn1y7FJd5X7x86G1A9s7wuXDdee/QTPxH7+7cOd85e3ze5p3V/RUnZpdFWs92wXnfPCybQyl7hh8murY8NZFvvuXkYNjxFFpNzN677c0s3bZ3DNkh7y8273Mcejgqvi2Syt7XxgFz7yzgF2x07eEHAl3NqTqVt5/5KPapt/PzN61eO+aB4gD63ZVjKETW9u8jk2vz6s+Fnxu4acff7Gx7rVFe05f2D4YfOXxNz88OVJ8jtyItQ49XAn2ff38WO8nLWUHvk8cPv3Tl8/2Hppxd+wr+bOh0aHDw/tPoZ1HFq9d8Nuv9428NKtlS2jvjvePb/3hD/6grebJ0S1/zjj1aDaXfwNR3WPl/REAAA=="
    
    // API headers containing the authorization
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    // Initialize with a default or provided session
    init(session: CardsProviderProtocol = CardsProvider()) {
        self.session = session
    }
    
    // MARK: - searchCards method
        // Searches for cards based on name and country, then triggers the completion handler with the results
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

        // Ensure the URL is valid
        guard let url = components?.url else {
            completion(.failure(.invalidURL))
                return
            }
        
        // Cancel the previous task if it exists
        task?.cancel()
        session.getRequest(url: url, headers: headers) { result in
            switch result {
            case let .success(data):
                do {
                    let responseJSON = try JSONDecoder().decode(ItemSearchResult.self, from: data)
                    
                    // Check if the response is empty and return appropriate results
                    if responseJSON.itemSummaries.isEmpty {
                        completion(.failure(.noCardsFound))
                    } else {
                        completion(.success(responseJSON))
                    }
                    
                } catch {
                    // Handle JSON decoding errors
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
