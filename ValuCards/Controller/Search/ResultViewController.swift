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
    var cardName: String?
    var selectedCountry: EbayCountry?
    let pricingService = CardPricingService()
    
    // MARK: - Outlets
    @IBOutlet weak var titleCardLabel: UILabel!
    @IBOutlet weak var containerAveragePrice: UIView!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var currencyAverageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var containerPrice: UIView!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var currencyLowestLabel: UILabel!
    @IBOutlet weak var averagePriceLabel2: UILabel!
    @IBOutlet weak var currencyAveragePriceLabel2: UILabel!
    @IBOutlet weak var highetsPriceLabel: UILabel!
    @IBOutlet weak var currencyHighestLabel: UILabel!
    @IBOutlet weak var cardsSaleLabel: UILabel!
    @IBOutlet weak var containerCharts: UIView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    // MARK: - Data
    var cards: [ValuCards.ItemSummary] = []
    
    // MARK: - Constants
    private let priceCategories: [PriceCategory] = [
        .init(range: 0...9, label: "0-9"),
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
        fetchCardDetails()
    }
    
    private func fetchCardDetails() {
        guard let title = cardTitle, let country = selectedCountry else {
            self.showAlert(for: .paysNonSelectionnée)
            return
        }
        
        CardsModel.shared.searchCards(withName: title, inCountry: country) { [weak self] result in
            switch result {
            case let .success(card):
                let averagePrice = self?.pricingService.getAveragePrice(from: card.itemSummaries)
                let lowestPrice = self?.pricingService.getLowestPrice(from: card.itemSummaries)
                let highestPrice = self?.pricingService.getHighestPrice(from: card.itemSummaries)
                self?.averagePrice = averagePrice
                self?.lowestPrice = lowestPrice
                self?.highestPrice = highestPrice
                self?.currency = card.itemSummaries.first?.price.currency
                self?.cards = card.itemSummaries
                self?.numberCardsSale = card.itemSummaries.count
                self?.setupViews()
                self?.categorizeData()
                self?.setupChart()
            case .failure(let error):
                print(error)
                self?.showAlert(for: .cardSearchError)
            }
        }
    }
    
    // MARK: - UI Configuration
    private func setupViews() {
        cardImageView.image = image
        titleCardLabel.text = cardTitle ?? ""
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        configurePriceLabels(with: currencySymbol)
        
        if let currencySymbol = currency?.currencySymbol() {
            currencyAverageLabel.text = currencySymbol
            averagePriceLabel.text = formatPrice(averagePrice)
        }
        
        applyShadowAndRoundedCorners(to: containerAveragePrice, shadowPosition: .bottom)
        applyShadowAndRoundedCorners(to: containerCharts, shadowPosition: .top)
        applyShadowAndRoundedCorners(to: containerPrice, shadowPosition: .top)
        containerCharts.alpha = 0.7
        containerPrice.alpha = 0.7
        containerAveragePrice.alpha = 0.7
    }
    
    private func applyShadowAndRoundedCorners(to view: UIView, shadowPosition: ViewHelper.ShadowPosition) {
        ViewHelper.applyShadowAndRoundedCorners(to: view, shadowPosition: shadowPosition)
    }
    
    private func configurePriceLabels(with symbol: String) {
        averagePriceLabel.text = formatPrice(averagePrice)
        lowestPriceLabel.text = formatPrice(lowestPrice)
        highetsPriceLabel.text = formatPrice(highestPrice)
        averagePriceLabel2.text = formatPrice(averagePrice)
        
        cardsSaleLabel.text = numberCardsSale.map { "\($0)" } ?? "N/A"
        
        currencyLowestLabel.text = symbol
        currencyAverageLabel.text = symbol
        currencyAveragePriceLabel2.text = symbol
        currencyHighestLabel.text = symbol
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
    private func setupChart() {
        var dataEntries: [PieChartDataEntry] = []
        
        let totalCards = cards.count
        for category in priceCategories {
            let count = Double(counts[category.label] ?? 0)
            let percentageValue = (count / Double(totalCards)) * 100
            
            let entry = PieChartDataEntry(value: percentageValue, label: "\(category.label) \(currency?.currencySymbol() ?? "")")
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
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
        
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawEntryLabelsEnabled = false
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        dataSet.valueLineColor = .white
        dataSet.valueLineWidth = 1.0
        dataSet.valueLinePart1OffsetPercentage = 0.8
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        let centerTextAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),  // Taille de la police et gras
            .foregroundColor: UIColor.black        // Couleur du texte
        ]

        let currencySymbol = currency?.currencySymbol() ?? ""
        let centerString = "Break-down by\nprice \(currencySymbol)\(formatPrice(averagePrice))"
        pieChartView.centerAttributedText = NSAttributedString(string: centerString, attributes: centerTextAttributes)
        
        pieChartView.legend.enabled = true
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.horizontalAlignment = .right
        pieChartView.legend.verticalAlignment = .center
        
        pieChartView.notifyDataSetChanged()
        pieChartView.setNeedsDisplay()
    }
}



// Cacher quand on swipe vers le haut
// https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621861-setviewcontrollers remanipuler le tableau
// https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621873-viewcontrollers // removefirst gérer l'écran de connexion et donc ajouter un bouton déconnexion
// Loader avant d'afficher la bonne vue
