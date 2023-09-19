//
//  ValuCards.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation

// Rajouter une fonction dedans
struct ItemSearchResult: Decodable {
    let href: String
    let total: Int
    let next: String?
    let limit: Int
    let offset: Int
    let itemSummaries: [ItemSummary]
}

struct ItemSummary: Decodable {
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


/*
 private func setupChart() {
     var dataEntries: [PieChartDataEntry] = []
     
     let totalCards = cards.count
     for category in priceCategories {
         let count = Double(counts[category.label] ?? 0)
         let percentageValue = (count / Double(totalCards)) * 100
         
         let entry = PieChartDataEntry(value: percentageValue, label: String(format: "%.0f%%", percentageValue))
         dataEntries.append(entry)
     }
     
     let dataSet = PieChartDataSet(entries: dataEntries, label: "")
     dataSet.colors = [
         NSUIColor.systemYellow,
         NSUIColor.systemCyan,
         NSUIColor.systemRed,
         NSUIColor.systemPink,
         NSUIColor.systemOrange,
         NSUIColor.systemPurple,
         NSUIColor.systemIndigo
     ]
     
     dataSet.xValuePosition = .outsideSlice
     dataSet.yValuePosition = .insideSlice
     dataSet.valueLinePart1Length = 0.2
     dataSet.valueLinePart2Length = 0.4
     dataSet.valueLineColor = .white
     dataSet.valueLineWidth = 1.0
     dataSet.valueLinePart1OffsetPercentage = 0.8
     
     let data = PieChartData(dataSet: dataSet)
     pieChartView.data = data
     
     let currencySymbol = currency?.currencySymbol() ?? ""
     pieChartView.centerText = "Break-down by\nprice \(currencySymbol)\(formatPrice(averagePrice))"
     
     pieChartView.legend.enabled = true
     pieChartView.notifyDataSetChanged()
     pieChartView.setNeedsDisplay()
 }
 */
