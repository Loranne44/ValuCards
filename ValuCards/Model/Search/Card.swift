//
//  ValuCards.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation

// MARK: - Data Models
struct ItemSearchResult: Decodable {
    let href: String
    let total: Int
    let next: String?
    let limit: Int
    let offset: Int
    let itemSummaries: [ItemSummary]
}

struct ItemSummary: Decodable {
    let itemId: String
    let title: String
    let leafCategoryIds: [String]
    let categories: [Category]
    //   let image: Image?
    let price: Price
    let thumbnailImages: [Image]?
}

struct Category: Decodable {
    let categoryId: String
    let categoryName: String
}

struct Image: Decodable {
    let imageUrl: String
}

struct Price: Decodable {
    let value: String
    let currency: String
}
