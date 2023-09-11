//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit
import DGCharts

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    var averagePrice: Double?
    var lowestPrice: Double?
    var highestPrice: Double?
    var currency: String?
    var image: UIImage?
    var cardTitle: String?
    var numberCardsSale: Int?
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inconePriceTrendLowest: UILabel!
    @IBOutlet weak var iconePriceTrendAverage: UILabel!
    @IBOutlet weak var iconePriceTrendHighest: UILabel!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var numberCardsSaleLabel: UILabel!
    @IBOutlet weak var priceChartView: BarChartView!
    @IBOutlet weak var titleCards: UILabel!
    
    
    // MARK: - Data
    var cards: [ValuCards.ItemSummary] = []
    
    // MARK: - Constants
    private let chartColor = NSUIColor.systemYellow
    private let priceCategories: [PriceCategory] = [
        .init(range: 1...4, label: "<5"),
        .init(range: 5...9, label: "5-9"),
        .init(range: 10...24, label: "10-24"),
        .init(range: 25...49, label: "25-49"),
        .init(range: 50...99, label: "50-99"),
        .init(range: 100...199, label: "100-199"),
        .init(range: 200...299, label: "200-299"),
        .init(range: 300...Int.max, label: "300+")
    ]
    private var counts: [String: Int] = [:]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        categorizeData()
        setupChart()
    }

    // MARK: - UI Configuration
    private func setupViews() {
        imageView.image = image
        titleCards.text = cardTitle ?? "Résultats"
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        configurePriceLabels(with: currencySymbol)
    }
    
    private func configurePriceLabels(with symbol: String) {
        averagePriceLabel.text = formatPrice(averagePrice)
        lowestPriceLabel.text = formatPrice(lowestPrice)
        highestPriceLabel.text = formatPrice(highestPrice)
        numberCardsSaleLabel.text = numberCardsSale.map { "\($0)" } ?? "N/A"
        
        inconePriceTrendLowest.text = symbol
        iconePriceTrendAverage.text = symbol
        iconePriceTrendHighest.text = symbol
    }
    
    // MARK: - Data Helpers
    private func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "NB" }
        return String(format: "%.2f", price)
    }
    
    private func categorizeData() {
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
    }
    
    // MARK: - Chart Configuration
    private func setupChart() {
        let filteredCounts = counts.filter { $0.value > 0 }
        
        let sortedKeys = Array(filteredCounts.keys).sorted {
            (key1, key2) in
            let index1 = priceCategories.firstIndex(where: { $0.label == key1 }) ?? 0
            let index2 = priceCategories.firstIndex(where: { $0.label == key2 }) ?? 0
            return index1 < index2
        }
        
        priceChartView.clear()
        
        let dataEntries = sortedKeys.enumerated().map {
            BarChartDataEntry(x: Double($0.offset), y: Double(filteredCounts[$0.element]!))
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Number of cards for sale")
        dataSet.colors = [chartColor]
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        dataSet.valueFormatter = DefaultValueFormatter(formatter: numberFormatter)
        
        let data = BarChartData(dataSet: dataSet)
        priceChartView.data = data
        priceChartView.xAxis.labelPosition = .bottom
        priceChartView.xAxis.setLabelCount(dataEntries.count, force: true)
        print("Sorted Keys: \(sortedKeys)")

        priceChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: sortedKeys)
        priceChartView.xAxis.granularity = 1
        priceChartView.xAxis.drawGridLinesEnabled = false
        priceChartView.leftAxis.enabled = false
        priceChartView.rightAxis.enabled = false
        
        let legend = priceChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.yOffset = 5
        legend.font = .systemFont(ofSize: 10)
        
        priceChartView.marker = nil
        
        dataSet.valueFont = .systemFont(ofSize: 15)
        dataSet.valueTextColor = .black
        dataSet.valueFormatter = IntValueFormatter()
        
        priceChartView.notifyDataSetChanged()
        priceChartView.setNeedsDisplay()
    }
    
    private class IntValueFormatter: ValueFormatter {
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            return String(Int(value))
        }
    }
    
    private class PriceCategory {
        var range: ClosedRange<Int>
        var label: String

        init(range: ClosedRange<Int>, label: String) {
            self.range = range
            self.label = label
        }
    }
}
