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
    var numberCardsSale: Int = 0
    
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
    
    var cards: [ValuCards.ItemSummary] = []
    
    // Constants for colors
    private let colorYellow = ChartColorTemplates.colorFromString("#FFD700")
    private let colorOrange = ChartColorTemplates.colorFromString("#FFA500")
    private let colorDarkRed = ChartColorTemplates.colorFromString("#FF4500")
    
    
    private let priceCategories: [(range: ClosedRange<Int>, label: String)] = [
        (1...1, "Only 1"),
        (5...9, "5 or more"),
        (10...24, "10 or more"),
        (25...49, "25 or more"),
        (50...99, "50 or more"),
        (100...199, "100 or more"),
        (200...299, "200 or more"),
        (300...Int.max, "300 or more")
    ]
    
    
    private var counts: [String: Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        categorizeData()
        setupChart()
    }
    
    private func initializeCounts() {
        for category in priceCategories {
            counts[category.label] = 0
        }
    }
    
    func setupViews() {
        if let passedImage = image {
            imageView.image = passedImage
        }
        
        let cardTitleDisplay = cardTitle ?? "Résultats"
        titleCards.text = cardTitleDisplay
        imageView.layer.cornerRadius = 30
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        
        averagePriceLabel.text = formatPrice(averagePrice)
        lowestPriceLabel.text = formatPrice(lowestPrice)
        highestPriceLabel.text = formatPrice(highestPrice)
        numberCardsSaleLabel.text = "\(numberCardsSale)"
        
        inconePriceTrendLowest.text = currencySymbol
        iconePriceTrendAverage.text = currencySymbol
        iconePriceTrendHighest.text = currencySymbol
    }
    
    func formatPrice(_ price: Double?) -> String {
        guard let price = price else { return "NB" }
        return String(format: "%.2f", price)
    }
    
    func categorizeData() {
        for card in cards {
            guard let priceValue = Int(card.price.value) else { continue }
            
            for category in priceCategories {
                if category.range.contains(priceValue) {
                    counts[category.label]! += 1
                    break
                }
            }
        }
    }
    
    func setupChart() {
        let dataEntries = counts.keys.sorted().enumerated().map {
            BarChartDataEntry(x: Double($0.offset), y: Double(counts[$0.element]!))
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Nombre de cartes disponibles")
        
        dataSet.colors = [colorYellow, colorOrange, colorDarkRed]
        
        let data = BarChartData(dataSet: dataSet)
        priceChartView.data = data
        
        priceChartView.xAxis.labelPosition = .bottom
        priceChartView.xAxis.setLabelCount(dataEntries.count, force: true)
        priceChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: counts.keys.sorted())
        priceChartView.xAxis.granularity = 1
        priceChartView.rightAxis.enabled = false
        priceChartView.legend.horizontalAlignment = .right
        priceChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}

/*var counts: [String: Int] = [
 "Only 1": 0,
 "5 or more": 0,
 "10 or more": 0,
 "25 or more": 0,
 "50 or more": 0,
 "100 or more": 0,
 "200 or more": 0,
 "300 or more": 0
 ]
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 setupViews()
 categorizeData()
 setupChart()
 }
 
 func setupViews() {
 if let passedImage = image {
 imageView.image = passedImage
 }
 let cardTitleDisplay = cardTitle ?? "Résultats"
 titleCards.text = cardTitleDisplay
 
 imageView.layer.cornerRadius = 30
 
 let currencySymbol = currency?.currencySymbol() ?? ""
 
 averagePriceLabel.text = formatPrice(averagePrice)
 lowestPriceLabel.text = formatPrice(lowestPrice)
 highestPriceLabel.text = formatPrice(highestPrice)
 numberCardsSaleLabel.text = "\(numberCardsSale)"
 
 inconePriceTrendLowest.text = currencySymbol
 iconePriceTrendAverage.text = currencySymbol
 iconePriceTrendHighest.text = currencySymbol
 }
 
 func formatPrice(_ price: Double?) -> String {
 guard let price = price else { return "NB" }
 return String(format: "%.2f", price)
 }
 
 func categorizeData() {
 // Reset counts before recounting
 counts = counts.mapValues { _ in 0 }
 
 for card in cards {
 guard let priceValue = Int(card.price.value) else { continue }
 
 switch priceValue {
 case 1:
 counts["Only 1"]! += 1
 case 2..<5:
 counts["5 or more"]! += 1
 case 5..<10:
 counts["10 or more"]! += 1
 case 10..<25:
 counts["25 or more"]! += 1
 case 25..<50:
 counts["50 or more"]! += 1
 case 50..<100:
 counts["100 or more"]! += 1
 case 100..<200:
 counts["200 or more"]! += 1
 case 200..<300:
 counts["300 or more"]! += 1
 default:
 continue
 }
 }
 }
 
 func setupChart() {
 let dataEntries = counts.keys.sorted().enumerated().map {
 BarChartDataEntry(x: Double($0.offset), y: Double(counts[$0.element]!))
 }
 
 let dataSet = BarChartDataSet(entries: dataEntries, label: "Nombre de cartes disponibles")
 
 dataSet.colors = [
 ChartColorTemplates.colorFromString("#FFD700"), // Jaune
 ChartColorTemplates.colorFromString("#FFA500"), // Orange
 ChartColorTemplates.colorFromString("#FF4500")  // Rouge foncé
 ]
 
 let data = BarChartData(dataSet: dataSet)
 priceChartView.data = data
 
 priceChartView.xAxis.labelPosition = .bottom
 priceChartView.xAxis.setLabelCount(dataEntries.count, force: true)
 priceChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: counts.keys.sorted())
 priceChartView.xAxis.granularity = 1
 priceChartView.rightAxis.enabled = false
 priceChartView.legend.horizontalAlignment = .right
 priceChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
 }
 } */




/*
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
 var numberCardsSale: Int = 0
 var cards: [ValuCards.ItemSummary] = []
 var counts: [String: Int] = [:]
 var graphData: [Double] = []
 
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
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 initializeCounts()
 categorizeData()
 print("After categorizeData: \(counts)")
 setupUI()
 setupChart()
 }
 
 private func initializeCounts() {
 counts = [
 "Only 1": 0,
 "5 or more": 0,
 "10 or more": 0,
 "25 or more": 0,
 "50 or more": 0,
 "100 or more": 0,
 "200 or more": 0,
 "300 or more": 0
 ]
 }
 
 private func categorizeData() {
 print("Number of cards: \(cards.count)")
 for card in cards {
 print("Price value of card: \(card.price.value)")
 
 guard let priceValue = Int(card.price.value) else { continue }
 
 switch priceValue {
 case 1:
 counts["Only 1"]! += 1
 case 2..<5:
 counts["5 or more"]! += 1
 case 5..<10:
 counts["10 or more"]! += 1
 case 10..<25:
 counts["25 or more"]! += 1
 case 25..<50:
 counts["50 or more"]! += 1
 case 50..<100:
 counts["100 or more"]! += 1
 case 100..<200:
 counts["200 or more"]! += 1
 case 200..<300:
 counts["300 or more"]! += 1
 default:
 continue
 }
 }
 print("Counts After categorizing: \(counts)")
 }
 
 private func setupUI() {
 titleCards.text = cardTitle ?? "Titre non disponible"
 
 if let passedImage = image {
 imageView.image = passedImage
 }
 imageView.layer.cornerRadius = 30
 let currencySymbol = currency?.currencySymbol() ?? ""
 
 averagePriceLabel.text = averagePrice != nil ? String(format: "%.2f", averagePrice!) : "NB"
 lowestPriceLabel.text = lowestPrice != nil ? String(format: "%.2f", lowestPrice!) : "NB"
 highestPriceLabel.text = highestPrice != nil ? String(format: "%.2f", highestPrice!) : "NB"
 numberCardsSaleLabel.text = "\(numberCardsSale)"
 
 inconePriceTrendLowest.text = currencySymbol
 iconePriceTrendAverage.text = currencySymbol
 iconePriceTrendHighest.text = currencySymbol
 }
 
 func setupChart() {
 var dataEntries: [BarChartDataEntry] = []
 let keysOrder = ["Only 1", "5 or more", "10 or more", "25 or more", "50 or more", "100 or more", "200 or more", "300 or more"]
 
 for (index, key) in keysOrder.enumerated() {
 if let countValue = counts[key] {
 let entry = BarChartDataEntry(x: Double(index), y: Double(countValue))
 dataEntries.append(entry)
 }
 }
 
 let dataSet = BarChartDataSet(entries: dataEntries, label: "")
 
 let gradientColors = [
 ChartColorTemplates.colorFromString("#FFD700"),
 ChartColorTemplates.colorFromString("#FFC100"),
 ChartColorTemplates.colorFromString("#FFAD00"),
 ChartColorTemplates.colorFromString("#FF9A00"),
 ChartColorTemplates.colorFromString("#FF8500"),
 ChartColorTemplates.colorFromString("#FF7000"),
 ChartColorTemplates.colorFromString("#FF5C00"),
 ChartColorTemplates.colorFromString("#FF4500")
 ]
 
 dataSet.colors = gradientColors
 
 let data = BarChartData(dataSet: dataSet)
 priceChartView.data = data
 
 priceChartView.xAxis.labelPosition = .bottom
 priceChartView.xAxis.setLabelCount(dataEntries.count, force: true)
 priceChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: keysOrder)
 priceChartView.xAxis.granularity = 1
 priceChartView.rightAxis.enabled = false
 
 // Désactiver la légende
 priceChartView.legend.enabled = false
 
 // Centrer le graphique
 let centerX = view.bounds.width / 2
 let centerY = view.bounds.height / 2
 let chartWidth = priceChartView.bounds.width
 let chartHeight = priceChartView.bounds.height
 priceChartView.frame = CGRect(x: centerX - chartWidth / 2, y: centerY - chartHeight / 2, width: chartWidth, height: chartHeight)
 
 priceChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
 }
 }
 
 */
