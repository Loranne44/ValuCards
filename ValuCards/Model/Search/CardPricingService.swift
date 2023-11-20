//
//  CardPricingService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/09/2023.
//

import Foundation

struct CardPricingService {
    
    // MARK: - Private Helper Methods
    private func prices(from cards: [ItemSummary]) -> [Double] {
        return cards.compactMap { Double($0.price.value) }
    }
    
    // MARK: - Pricing Metrics
    func getAveragePrice(from cards: [ItemSummary]) -> Double {
        if cards.isEmpty {
            return 0.0
        }
        let prices = self.prices(from: cards)
        let sum = prices.reduce(0, +)
        return sum / Double(cards.count)
    }
    
    func getLowestPrice(from cards: [ItemSummary]) -> Double {
        return prices(from: cards).min() ?? 0.0
    }
    
    func getHighestPrice(from cards: [ItemSummary]) -> Double {
        return prices(from: cards).max() ?? 0.0
    }
}