//
//  ValuCards.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation

struct EbayBrowseResponse: Decodable {
    let items: [EbayItem]
}


struct EbayItem: Decodable {
    let title: String
    let price: Double
    let condition: String
    let shipping: EbayShipping
}

struct EbayShipping: Decodable {
    let price: Double
    let type: String
}

