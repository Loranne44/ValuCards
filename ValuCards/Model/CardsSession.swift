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
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                    completion(.success(jsonData))
                } else {
                    completion(.failure(.errorDecode2))
                }
            case .failure(_):
                completion(.failure(.errorDecode2))
            }
        }
    }
}

/*
 protocol CardsProviderProtocol {
     func getRequest(url: URL, headers: HTTPHeaders,completion: @escaping (Result<Data, ErrorCase>) -> Void)
 }

 class CardsProvider: CardsProviderProtocol {
     
     func getRequest(url: URL,  headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void) {
         
         let headers: HTTPHeaders = ["Authorization": "Bearer \(CardsModel.apiKey)"]
         AF.request(url,
                    method: .get,
                    headers: headers,
                    interceptor: nil)
         .validate(statusCode: 200..<600)
         .responseDecodable(of: ItemSummary.self) { response in
             
             guard let data = response.data else {
                 completion(.failure(.errorDecode2))
                 return
             }
             print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "")")
             completion(.success(data))
         }
     }
 }

 */
