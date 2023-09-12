//
//  CardsSession.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation
import Alamofire

// Protocol to ensure proper structure for card providers
protocol CardsProviderProtocol {
    func getRequest(url: URL, headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void)
}

class CardsProvider: CardsProviderProtocol {
    // Implement the GET request method using Alamofire
    func getRequest(url: URL,  headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void) {
        
        // Make a GET request with validation
        AF.request(url,
                   method: .get,
                   headers: headers,
                   interceptor: nil)
        .validate(statusCode: 200..<600)
        .responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 404:
                        completion(.failure(.noCardsFound))
                    case 500..<600:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.generalNetworkError))
                    }
                } else {
                    completion(.failure(.requestFailed(error: error)))
                }
            }
        }
    }
}
