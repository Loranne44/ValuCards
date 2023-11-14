//
//  CardsSession.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation
import Alamofire
import Firebase
import FirebasePerformance

// MARK: - Cards Provider Protocol
protocol CardsProviderProtocol {
    func getRequest(url: URL, headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void)
}

// MARK: - Cards Provider Implementation
class CardsProvider: CardsProviderProtocol {
    func getRequest(url: URL,  headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void) {
        let trace = Performance.startTrace(name: "network_request_to_\(url.path)")

        AF.request(url,
                   method: .get,
                   headers: headers,
                   interceptor: nil)
        .validate(statusCode: 200..<600)
        .responseData { response in
            trace?.stop()

            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                if let statusCode = response.response?.statusCode {
                    switch statusCode {
                    case 404:
                        completion(.failure(.resourceNotFound))
                    case 500..<600:
                        completion(.failure(.serverError))
                    default:
                        completion(.failure(.generalNetworkError))
                    }
                } else {
                    completion(.failure(.requestFailed))
                }
            }
        }
    }
}

// A TESTER
