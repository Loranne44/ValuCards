//
//  ChartManager.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 10/10/2023.
//

import Foundation
import UIKit
import DGCharts

class ChartManager {
    
    private let priceCategories: [PriceCategory] = [
        .init(range: 0...9, label: "0-9"),
        .init(range: 10...24, label: "10-24"),
        .init(range: 25...49, label: "25-49"),
        .init(range: 50...99, label: "50-99"),
        .init(range: 100...199, label: "100-199"),
        .init(range: 200...299, label: "200-299"),
        .init(range: 300...Int.max, label: "300+")
    ]
    
    /// Sets up a PieChartView using card data.
    func setupPieChartView(pieChartView: PieChartView, cards: [ValuCards.ItemSummary], currency: String?) {
        var counts: [String: Int] = [:]
        for card in cards {
            if let priceValueDouble = Double(card.price.value) {
                let priceValue = Int(priceValueDouble)
                for category in priceCategories {
                    if category.range.contains(priceValue) {
                        counts[category.label, default: 0] += 1
                        break
                    }
                }
            }
        }

        var dataEntries: [PieChartDataEntry] = []
        
        let totalCards = cards.count
        for category in priceCategories {
            let count = Double(counts[category.label] ?? 0)
            let percentageValue = (count / Double(totalCards)) * 1000
            
            let entry = PieChartDataEntry(value: percentageValue, label: "\(category.label) \(currency?.currencySymbol() ?? "")")
            dataEntries.append(entry)
        }

        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [
            NSUIColor.systemGray,
            NSUIColor.systemRed,
            NSUIColor.systemYellow,
            NSUIColor.systemGreen,
            NSUIColor.systemOrange,
            NSUIColor.systemPurple,
            NSUIColor.systemIndigo
        ]
        
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .insideSlice
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        pieChartView.legend.enabled = true
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.verticalAlignment = .center
        
        pieChartView.notifyDataSetChanged()
        pieChartView.setNeedsDisplay()
    }
}
