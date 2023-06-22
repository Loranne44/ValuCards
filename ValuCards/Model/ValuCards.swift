//
//  ValuCards.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation

struct Card: Codable {
    let title: String
    let price: Price
    let sellingStatus: SellingStatus
    
    struct Price: Codable {
        let value: Double
    }
    
    struct SellingStatus: Codable {
        let soldQuantity: Int
    }
}
