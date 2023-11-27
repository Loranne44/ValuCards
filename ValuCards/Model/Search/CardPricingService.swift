//
//  CardPricingService.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/09/2023.
//

import Foundation

struct CardPricingService {
    
    // MARK: - Private Helper Methods
    /// Extracts price values from a list of card item summaries
    private func prices(from cards: [ItemSummary]) -> [Double] {
        return cards.compactMap { Double($0.price.value) }
    }
    
    // MARK: - Pricing Metrics
    /// Calculates the average price of a collection of cards
    func getAveragePrice(from cards: [ItemSummary]) -> Double {
        if cards.isEmpty {
            return 0.0
        }
        let prices = self.prices(from: cards)
        let sum = prices.reduce(0, +)
        return sum / Double(cards.count)
    }
    
    /// Determines the lowest price from a collection of cards
    func getLowestPrice(from cards: [ItemSummary]) -> Double {
        return prices(from: cards).min() ?? 0.0
    }
    
    /// Determines the highest price from a collection of cards
    func getHighestPrice(from cards: [ItemSummary]) -> Double {
        return prices(from: cards).max() ?? 0.0
    }
}
