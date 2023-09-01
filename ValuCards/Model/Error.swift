//
//  Error.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation

enum ErrorCase: Error {
    case errorDecode
    case errorDecode1
    case errorDecode2
    case errorDecode3
    case errorDecode4
    case noCardsFound
    
    var message : String {
        switch self {
        case .errorDecode:
            return "Sorry, no JSON"
        case .errorDecode1:
            return "Sorry, no JSON"
        case .errorDecode2:
            return "Sorry, no JSON"
        case .errorDecode3:
            return "Sorry, no JSON"
        case .errorDecode4:
            return "Sorry, no JSON"
        case .noCardsFound:
            return "Entrer un nom de carte"
    
        }
    }
}
