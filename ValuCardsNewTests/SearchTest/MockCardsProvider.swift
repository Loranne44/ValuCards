//
//  MockCardsProvider.swift
//  ValuCardsTests
//
//  Created by Loranne Joncheray on 16/10/2023.
//

import Foundation
import Alamofire
@testable import ValuCards

/// Mock class for simulating network requests for card data.
class MockCardsProvider: CardsProviderProtocol {
    var data: Data?
    var error: ErrorCase?

    /// Custom implementation of a network request, providing either mocked data or error.
    func getRequest(url: URL, headers: HTTPHeaders, completion: @escaping (Result<Data, ErrorCase>) -> Void) {
        if let data = data {
            completion(.success(data))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}

