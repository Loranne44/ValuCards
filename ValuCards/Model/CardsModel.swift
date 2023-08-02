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
    static let apiKey = "v^1.1#i^1#r^0#p^1#I^3#f^0#t^H4sIAAAAAAAAAOVYfWwTZRhv90XGZ4h8ZRIph8bAvOt71/Z2d9Jit3auY590kA6B8fbu7XasvTvvrmxFJXOamRAVQ0JAETIj/AH6h5hoNGYGiYGFEIOiSARiYgRJ5I8xRRQFfK/rRjcJIGviEvtPc8/7vM/7+/3e53m/QFdR8ZKeqp6r0+yT8nq7QFee3U5PAcVFhaXT8/NKCm0gy8He2/VwV0F3/sWlBkzENWEFMjRVMZCjMxFXDCFt9BJJXRFUaMiGoMAEMgRTFML+2hqBoYCg6aqpimqccIQCXoL1cGVRGHVL7hgq88QkbFWGYzapXsKDEC/xgI+ykkhzCOF2w0iikGKYUDG9BAMYFwk4EjBNgBNcvMBwFOeiVxOOVUg3ZFXBLhQgfGm4QrqvnoX1zlChYSDdxEEIX8hfGa73hwLBuqalzqxYvowOYROaSWP0V4UqIccqGE+iOw9jpL2FcFIUkWEQTt/QCKODCv5hMPcBPy212+2KcmVsGRN1s1wUwZxIWanqCWjeGYdlkSUylnYVkGLKZupuimI1ohuQaGa+6nCIUMBh/TUmYVyOyUj3EsFyf7O/oYHw1ag6VBRUTVpqV0BdIhtWBEgPzwKe4crcJA89CLK0OzPQULSMzGNGqlAVSbZEMxx1qlmOMGo0VhsmSxvsVK/U6/6YaSHK8qPBsIYM9nMOz2LSbFOseUUJLIQj/Xn3GRjpbZq6HE2aaCTC2Ia0RF4CaposEWMb07mYSZ9Ow0u0maYmOJ0dHR1Uh4tS9VYnAwDtjNTWhMU2lMAZ0pmwan3IX757B1JOUxFxmWJ/wUxpGEsnzlUMQGklfO4yjgFcRvfRsHxjrf8wZHF2jq6IXFUIB1jWJULWjTzQ5YZ8LirEl0lSp4UDRWGKTEC9HZlaHIqIFHGeJRNIlyXB5YkxLi6GSInlY6Sbj8XIqEdiSTqGEEAoGhV57v9UKPea6mEk6sjMSa7nLM+r2p3+Jk1uDHgqE2FzY6WWTKUivNS5IQK1ECtH+MbS5pV1kfJITa33XqvhtuQr4jJWpgmPnwsBrFrPoQiqYSJpXPTCoqqhBjUui6mJNcEuXWqAupkKo3gcG8ZF0q9podys1Tmj9y+Xifvjnbs96j/an27LyrBSdmKxsvobOADUZMragShRTTitWlchPn5Y5pY06nHxlvHJdUKxxiSH2MrS0JGTStOljI0ipSNDTer4tE3VWyewJrUdKXg/M3U1Hkf6Knrc9ZxIJE0YjaOJVtg5SHAZTrDNlmbx/ZD1eNjx8RLTW2nLRFuScrEUFzx5n8dq5+hLvs+W/tHd9sOg2/5pnt0OloJH6EVgYVH+yoL8qSWGbCJKhjHKkFsVfHfVEdWOUhqU9bwHbFfBT7vES1X7t7Tf6Hj6wuPP2bLfGHrXgnkjrwzF+fSUrCcHMP9WSyE9Y+40xgU4gPPYhSVYDRbdai2g5xTMemjt6b4/z7u2imeOVBUfXb697fIT18C0ESe7vdBW0G23Leu/YPuotl97/1KwYsHnpTxg5/8iL3nxRk9ndM+g/ahHn3rldHPfQN8mvrc22HLm1a+3SsVH910PnM/rOBUs/njb7IORgYFnQMmBE69sqbi4pujXPa/Tvd/NOBn/sfqt48r6KYeOBcjNry37bftx5oVHf6e+oDzBD4p+eL567oOLQ3PeOHxsySb13ORtM9/LX/zOJ5PX7L28cPZjh3evOxR7qpFePOvSYP/gz19+v0+eFdm5S3vzs2db1ZYdk9eXvLy5Z45IfQumn+0+Kc/rPrf3pbPXT0ySd/g2Nu4sjc0YmHRz3aa/Pjz51eCp8pnO8iN9Nw7uYr659u6CyisHQpU395f7lvdrwebdbzv4P4bm8m+pGQNj/REAAA=="
    
    
    let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
    
    
    // MARK: - searchCards
    func searchCards(withName name: String, completion: @escaping (Result<EbayBrowseResponse, ErrorCase>) -> Void) {
        
        let urlString = "https://api.ebay.com/buy/browse/v1/item_summary/search?q=\(name)&limit=3"
        
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
                    let responseJSON = try JSONDecoder().decode(EbayBrowseResponse.self, from: data)
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

