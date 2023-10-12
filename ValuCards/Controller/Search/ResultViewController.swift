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
    let chartManager = ChartManager()
    
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
    private func setupBackgroundImageView() {
        self.setupBackgroundImageView(for: backgroundImageView, with: scrollView)
    }
    
    // MARK: - Data Fetching
    func fetchCardDetails(completion: @escaping () -> Void) {
        guard let title = cardTitle, let country = selectedCountry else {
            self.showAlert(for: .countryNotSelected)
            completion()
            return
        }
        
        CardsModel.shared.searchCards(withName: title, inCountry: country) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(card):
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
            averagePriceLabel.text = NumberFormatter.formatPrice(averagePrice)
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



// Cacher quand on swipe vers le haut __OK
//https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621861-setviewcontrollers remanipuler le tableau
//https://developer.apple.com/documentation/uikit/uinavigationcontroller/1621873-viewcontrollers // removefirst gérer l'écran de connexion et donc ajouter un bouton déconnexion

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

//https://stackoverflow.com/questions/60801204/how-to-use-navigation-controller-on-a-view-after-user-logs-into-the-app
//https://medium.com/nerd-for-tech/ios-how-to-transition-from-login-screen-to-tab-bar-controller-b0fb5147c2f1

// créer un appel api searchByImage qui prends en parametre l'image renvoyer lors du swipe ou validation boutton de l'utilisateur. Fait une recherche via cette image et donne les caractéristiques de prix lors du result ViewController
