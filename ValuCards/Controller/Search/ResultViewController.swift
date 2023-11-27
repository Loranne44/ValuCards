//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit
import DGCharts
import FirebasePerformance

class ResultViewController: UIViewController {
    
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
    var cards: [ValuCards.ItemSummary] = []
    
    // MARK: - Services and Constants
    let pricingService = CardPricingService()
    let chartManager = ChartManager()
    var loadingViewController: LoadingViewController?
    
    // MARK: - UI Elements
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupBackgroundImageView()
        fetchCardDetails {
            self.setupViews()
            self.chartManager.setupPieChartView(pieChartView: self.pieChartView, cards: self.cards, currency: self.currency)
            self.loadingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Initialization Methods
    /// Sets up the background image view for the scroll view
    private func setupBackgroundImageView() {
        self.setupBackgroundImageView(for: backgroundImageView, with: scrollView)
    }
    
    // MARK: - Data Fetching
    /// Fetches details of the selected card and processes the result
    func fetchCardDetails(completion: @escaping () -> Void) {
        guard let title = cardTitle, let country = selectedCountry else {
            showAlert(for: .countryNotSelected)
            completion()
            return
        }
        
        let trace = Performance.startTrace(name: "fetch_card_details")

        CardsModel.shared.searchCards(withName: title, inCountry: country) { [weak self] result in
            defer {
                trace?.stop()
                completion()
            }

            switch result {
            case let .success(card):
                self?.processCardSearchResults(card)
            case .failure(let error):
                self?.handleSearchError(error)
            }
        }
    }
    
    /// Processes the results of the card search and updates the UI accordingly
    private func processCardSearchResults(_ card: ItemSearchResult) {
        var filteredCards = card.itemSummaries
        filteredCards.sort(by: { $0.price.value < $1.price.value })
        
        if filteredCards.count > 2 {
            filteredCards.removeFirst()
            filteredCards.removeLast()
        }
        
        self.averagePrice = self.pricingService.getAveragePrice(from: filteredCards)
        self.lowestPrice = self.pricingService.getLowestPrice(from: filteredCards)
        self.highestPrice = self.pricingService.getHighestPrice(from: filteredCards)
        self.currency = filteredCards.first?.price.currency
        self.cards = filteredCards
        self.numberCardsSale = filteredCards.count
        
        self.setupViews()  // Configure the UI based on the fetched card data
        self.chartManager.setupPieChartView(pieChartView: self.pieChartView, cards: self.cards, currency: self.currency)
        self.loadingViewController?.dismiss(animated: true, completion: nil)
    }

    /// Handles any errors that occur during the search process
    private func handleSearchError(_ error: ErrorCase) {
        print(error)
        showAlert(for: .cardSearchError)
        self.loadingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UI Configuration
    /// Sets up various UI elements based on fetched card data
    private func setupViews() {
        cardImageView.image = image
        titleCardLabel.text = cardTitle ?? ""
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        configurePriceLabels(with: currencySymbol)
        
        if let currencySymbol = currency?.currencySymbol() {
            currencyAverageLabel.text = currencySymbol
            averagePriceLabel.text = NumberFormatter.formatPrice(averagePrice)
        }
        
        applyShadowAndRoundedCorners(to: containerAveragePrice, shadowPosition: .bottom)
        applyShadowAndRoundedCorners(to: containerCharts, shadowPosition: .top)
        applyShadowAndRoundedCorners(to: containerPrice, shadowPosition: .top)
        containerCharts.alpha = 0.7
        containerPrice.alpha = 0.7
        containerAveragePrice.alpha = 0.7
    }
    
    /// Applies shadow and rounded corners to the given view
    private func applyShadowAndRoundedCorners(to view: UIView, shadowPosition: ViewHelper.ShadowPosition) {
        ViewHelper.applyShadowAndRoundedCorners(to: view, shadowPosition: shadowPosition)
    }
    
    /// Configures labels for displaying prices
    private func configurePriceLabels(with symbol: String) {
        averagePriceLabel.text = NumberFormatter.formatPrice(averagePrice)
        lowestPriceLabel.text = NumberFormatter.formatPrice(lowestPrice)
        highetsPriceLabel.text = NumberFormatter.formatPrice(highestPrice)
        averagePriceLabel2.text = NumberFormatter.formatPrice(averagePrice)
        
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
}
