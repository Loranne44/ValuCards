//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit
import DGCharts

class ResultViewController: UIViewController {
    var averagePrice: Double?
    var lowestPrice: Double?
    var highestPrice: Double?
    var currency: String?
    var image: UIImage?
    var numberCardsSale: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inconePriceTrendLowest: UILabel!
    @IBOutlet weak var iconePriceTrendAverage: UILabel!
    @IBOutlet weak var iconePriceTrendHighest: UILabel!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var numberCardsSaleLabel: UILabel!
    @IBOutlet weak var chartView: BarChartView!
    
    var cards: [ValuCards.ItemSummary] = []
    
    var counts: [String: Int] = [
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
        
        // Preprocess data
               categorizeData()
        
        if let passedImage = image {
            imageView.image = passedImage
        }
        
        imageView.layer.cornerRadius = 30
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        
        averagePriceLabel.text = averagePrice != nil ? String(format: "%.2f", averagePrice!) : "NB"
        lowestPriceLabel.text = lowestPrice != nil ? String(format: "%.2f", lowestPrice!) : "NB"
        highestPriceLabel.text = highestPrice != nil ? String(format: "%.2f", highestPrice!) : "NB"
        numberCardsSaleLabel.text = "\(numberCardsSale)"
        
        // numberCardsSale ->  fonctionner par palier : Only 1, 5 or more, 10 or more / 25 or more/ 50 or more/ 100 or more/ 200 or more / 300 or more
        
        inconePriceTrendLowest.text = currencySymbol
        iconePriceTrendAverage.text = currencySymbol
        iconePriceTrendHighest.text = currencySymbol
        
        // Setup chart
        setupChart()
    }
    
    func categorizeData() {
        // Réinitialisez les comptes avant de les recompter
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

        for card in cards {
                // Convertir le prix en Int
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
        var dataEntries: [BarChartDataEntry] = []
        let keysOrder = ["Only 1", "5 or more", "10 or more", "25 or more", "50 or more", "100 or more", "200 or more", "300 or more"]
        
        for (index, key) in keysOrder.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: Double(counts[key]!))
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Nombre de cartes disponibles")
        
        let gradientColors = [
            ChartColorTemplates.colorFromString("#FFD700"), // Jaune
            ChartColorTemplates.colorFromString("#FFA500"), // Orange
            ChartColorTemplates.colorFromString("#FF4500"), // Rouge foncé
            // ... Vous pouvez ajouter plus de couleurs si nécessaire
        ]
        
        dataSet.colors = gradientColors
        
        let data = BarChartData(dataSet: dataSet)
        chartView.data = data
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(dataEntries.count, force: true)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: keysOrder)
        chartView.xAxis.granularity = 1
        chartView.rightAxis.enabled = false
        chartView.legend.horizontalAlignment = .right
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

}
