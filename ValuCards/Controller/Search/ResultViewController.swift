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
    var loadingViewController: LoadingViewController?
    
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationItem.backBarButtonItem = backBarButton
        setupBackgroundImageView()
        
        fetchCardDetails {
            self.setupViews()
            self.categorizeData()
            self.setupChart()
            self.loadingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Initialization Methods
    private func setupBackgroundImageView() {
        self.view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        
        self.view.backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Data Fetching
    func fetchCardDetails(completion: @escaping () -> Void) {
        guard let title = cardTitle, let country = selectedCountry else {
            self.showAlert(for: .paysNonSelectionnée)
            completion() // Added completion here to ensure it gets called even if there is an error
            return
        }
        
        CardsModel.shared.searchCards(withName: title, inCountry: country) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(card):
                self.averagePrice = self.pricingService.getAveragePrice(from: card.itemSummaries)
                self.lowestPrice = self.pricingService.getLowestPrice(from: card.itemSummaries)
                self.highestPrice = self.pricingService.getHighestPrice(from: card.itemSummaries)
                self.currency = card.itemSummaries.first?.price.currency
                self.cards = card.itemSummaries
                self.numberCardsSale = card.itemSummaries.count
                
            case .failure(let error):
                print(error)
                self.showAlert(for: .cardSearchError)
                self.loadingViewController?.dismiss(animated: true, completion: nil)
            }
            completion()
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
        
        if let numberCardsSale = numberCardsSale {
            cardsSaleLabel.text = "Based on \(numberCardsSale) " + (numberCardsSale == 1 ? "card in sale" : "cards in sales")
        } else {
            cardsSaleLabel.text = "N/A"
        }
        
        currencyLowestLabel.text = symbol
        currencyAverageLabel.text = symbol
        currencyAveragePriceLabel2.text = symbol
        currencyHighestLabel.text = symbol
    }
    
    // MARK: - Data Manipulation
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
    
    // MARK: - Chart Setup
    private func setupChart() {
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
            NSUIColor.systemCyan,
            NSUIColor.systemRed,
            NSUIColor.systemYellow,
            NSUIColor.systemMint,
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



// Cacher quand on swipe vers le haut __OK
// https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621861-setviewcontrollers remanipuler le tableau
// https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621873-viewcontrollers // removefirst gérer l'écran de connexion et donc ajouter un bouton déconnexion

// Loader avant d'afficher la bonne vue __OK
// Mettre les US par défaut et enregistrer le choix précédant pour le réafficher a la prochaine connexion __OK
// Le back en blanc avec une classe __ OK
// inscription/Connexion Google/facebook / Apple
// Tests
// Changer les logos
// Mémoriser l'utilisateur connecté __OK
// Décaler l'appel réseau qui affiche le graphique dans le slide et non le search ? __OK

// Favoris ? Garder dans l'application et que ca ne puisse pas etre transmis ??
// Dark mode ??


// https://stackoverflow.com/questions/60801204/how-to-use-navigation-controller-on-a-view-after-user-logs-into-the-app
//https://medium.com/nerd-for-tech/ios-how-to-transition-from-login-screen-to-tab-bar-controller-b0fb5147c2f1



// créer un appel api searchByImage qui prends en parametre l'image renvoyer lors du swipe ou validation boutton de l'utilisateur. Fait une recherche via cette image et donne les caractéristiques de prix lors du result ViewController



/*
 "localizedAspects": [
     {
       "type": "STRING",
       "name": "Card Name / Card Number",
       "value": "Raichu - 026/165 Holo Rare"
     },
 */
