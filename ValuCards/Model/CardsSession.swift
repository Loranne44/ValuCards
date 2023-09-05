//
//  CardsSession.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation
import Alamofire

protocol CardsProviderProtocol {
    func getRequest(url: URL, headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void)
}

class CardsProvider: CardsProviderProtocol {
    func getRequest(url: URL,  headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void) {
        
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
