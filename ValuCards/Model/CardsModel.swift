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
    static let apiKey = "v^1.1#i^1#I^3#p^1#r^0#f^0#t^H4sIAAAAAAAAAOVYW2wUVRjudttCBcSIUDUI60A0FGb2zM7udnbCLtne6NbSi1tKaUWcy5l27FyWOTO0S7xU5JYQ40OjBBNIE0nkAYlERBFJVOKlkRBISApeeMEQhaAkCPJi9MzsUraVQKGb2MR92cw5//+f//vOfznngP6S0vItdVv+nOGZUjjYD/oLPR56GigtKV78oLfw8eICkCPgGexf2F+00fvLUsRraop7FqKUoSPo69NUHXHuYJSwTZ0zeKQgTuc1iDhL5JLxFQ1cgAJcyjQsQzRUwpeojhIyH4EsC4AoyLIEgxIe1W/abDWiBCvIAsNWsGwQVDABkcHzCNkwoSOL160oEQABhgRhMhBppSMcoDnAUiGW6SB8bdBEiqFjEQoQMdddztU1c3y9s6s8QtC0sBEilojXJpviieqaxtal/hxbsSwPSYu3bDT6q8qQoK+NV21452WQK80lbVGECBH+WGaF0Ua5+E1n7sN9l2o6SIcYKRwEAhuukEOBvFBZa5gab93ZD2dEkUjZFeWgbilW+m6MYjaEF6FoZb8asYlEtc/5a7F5VZEVaEaJmsr46nhzMxFrMExe12E96bBdxZsSmaxsx0BCclhmI4AMSAwAkihkF8pYy9I8ZqUqQ5cUhzTkazSsSoi9hqO5YblQDjdYqElvMuOy5XiUIxegb3JYEe5wNjWzi7bVrTv7CjVMhM/9vPsOjGhblqkItgVHLIydcCmKEnwqpUjE2Ek3FrPh04eiRLdlpTi/v7e3l+plKMPs8gcAoP3tKxqSYjfUeALLOrmekVfurkAqLhQRYk2kcFY6hX3pw7GKHdC7iFgQBCsYkOV9tFuxsaP/GsjB7B+dEfnKEJwgsgREPkILAkuDYD4yJJYNUr/jBxT4NKnxZg+0UiovQlLEcWZr0FQkjgnJAYaVISmFIzIZjMgyKYSkMEnLEAIIBUGMsP+nRBlvqCehaEIrL7GetziX2DS/WAtEzJ7eVHhlsHZdiyapifWNlV2tcXuVWb1a3VCzjun1092J6Hiz4bbgq1QFM9OK188HAU6u54+EOgNZUJoQvKRopGCzoSpienJtMGNKzbxppSvtNP5OQlXFfxOCGk+lEvmp2HkDeY/F4v5w569T/Udd6raokBO4kwuVo4+wAT6lULgPObmepkRD8xs8PoQ4w2tdr31jBG8r5BfsNNVlQ2RhTyR8Dhy3koKLOYVbmjR+lUzDxCDGr4IvGZItWve1kNuZKcym0tVtoXtas28ipAi22jN+FQny6oRCVMFXjUkVoBhpBrIiZe4IlIubQutFyoTIsE18PaKanCNzq9EDdXwAsUxDVaHZRk+49GqabfGCCidbDc5DLVJwrntuTLITEh3Gt/5wKBBmJ4RNdM8/aydbB8l357yHm5B/9LtMrMD90Rs9R8FGz+FCjwdUAJJeDBaVeFcWeacTCNceCvG6JBh9lMLLFC57Om/ZJqR6YDrFK2ZhiUf5/rR4I+dFaHANeHTkTajUS0/LeSACc2/NFNMzy2YEGBAOROgIoAHbARbcmi2i5xQ9QiSuTtm8/YR4Znrdsfc37N5T//C388GMESGPp7gAh29BwfW5l72hN8t2wJnPD7+bFk4PDB4t3LZs4BSZWH7oUnBJu/b13x93fnp+qH6gvPmLUua9I9d2HTgMv7O3nfux4OCa5VeGVh6+srXi7AdPL9jzdu2maa/VH/hq9u4vP9IuzHqs7JXVF/e27expWXjypZ92HfQV7hio++bJLR8e+nx+Xcfloa3lsz/xmkXnOwdfeODlI1pk+25zuFwuJomyZzY917nonbcSxx/a+/ucJ86BfQ3LLqn70dVrb3jPXFjha7oYr6npP30u+PrJg69eTrcUrdk0dOqPsxueihmxgeFZ7aXHK826qT8vsff+ZU89tn8eOzx955QfTuybt7zvs/rtl35dOPu3VRdaru/YnOhcmtnGfwApy5UjqxMAAA=="
    
    //"https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(encodedSearchKeyword)&filter=category_ids:{183473}&limit=400"
   
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<Card, ErrorCase>) -> Void) {
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
                guard let responseJSON = try? JSONDecoder().decode(Card.self, from: data) else {
                    completion(.failure(.errorDecode4))
                    return
                }
                completion(.success(responseJSON))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
