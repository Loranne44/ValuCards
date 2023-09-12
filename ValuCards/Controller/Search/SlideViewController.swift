//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit

class SlideViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Data models and services
    var imagesAndTitlesAndPrices: [(imageName: String, title: String, price: Price)] = []
    var slideResponseModel: ResponseModel!
    let pricingService = CardPricingService()
    var totalCardCount: Int?
    var selectedCountry: EbayCountry?
    
    // Gesture and image services
    private let cardGestureHandler = CardGestureHandler()
    private let imageService = ImageService()
    private let colorFilterService = ColorFilterService()
    private var initialPanPoint: CGPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initial setup
        setupImageView()
        setupGestureRecognizers()
        prepareDataModel()
        updateImageAndTitle()
    }
    
    // Setting up the image view properties
    private func setupImageView() {
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 9.0
        imageView.isUserInteractionEnabled = true
    }
    
    // Adding gesture recognizers to the image view
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        imageView.addGestureRecognizer(panGesture)
    }
    
    // Preparing the data model for the slides
    private func prepareDataModel() {
        let cardItems = imagesAndTitlesAndPrices.map { CardItem(imageName: $0.imageName, title: $0.title, price: $0.price) }
        slideResponseModel = ResponseModel(cardItems: cardItems)
        totalCardCount = slideResponseModel.cardItems.count
    }
    
    // Handling pan gestures on the image view
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initialPanPoint = gesture.translation(in: imageView)
        case .changed:
            performCardAction(with: gesture.translation(in: imageView))
            applyColorFilter()
        case .ended, .cancelled:
            imageView.alpha = 1.0
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = .identity
            }
            
            let translationX = gesture.translation(in: imageView).x
            if translationX > 0 {
                fetchCardDetails(for: slideResponseModel.getCurrentTitle())
            } else {
                slideResponseModel.showNextImage()
                updateImageAndTitle()
                resetColorFilter()
            }
        default:
            break
        }
    }
    
    // Fetching card details based on the title
    private func fetchCardDetails(for title: String) {
        guard let country = selectedCountry else {
            self.showAlert(for: .paysNonSelectionnée)
               return
           }
        CardsModel.shared.searchCards(withName: title, inCountry: country) { [weak self] result in
            switch result {
            case let .success(card):
                let averagePrice = self?.pricingService.getAveragePrice(from: card.itemSummaries)
                let lowestPrice = self?.pricingService.getLowestPrice(from: card.itemSummaries)
                let highestPrice = self?.pricingService.getHighestPrice(from: card.itemSummaries)
                let searchedCardCount = card.itemSummaries.count
                if let currency = card.itemSummaries.first?.price.currency {
                    self?.navigateToResultViewController(
                        with: averagePrice,
                        lowest: lowestPrice,
                        highest: highestPrice,
                        currency: currency,
                        numberCardsSale: searchedCardCount,
                        cards: card.itemSummaries
                    )
                }
            case .failure(_):
                self?.showAlert(for: .cardSearchError)
            }
        }
    }
    
    // Updating the image and title for the card
    func updateImageAndTitle() {
        let imageUrlString = slideResponseModel.getCurrentImageName()
        var title = slideResponseModel.getCurrentTitle()
        
        if title.isEmpty {
            title = "NB"
        }
        titleLabel.text = title
        
        imageService.downloadImage(from: imageUrlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image ?? UIImage(named: "defaultImage")
            }
        }
    }
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
        updateImageAndTitle()
    }
    
    @IBAction func validateImageButton(_ sender: UIButton) {
        fetchCardDetails(for: slideResponseModel.getCurrentTitle())
        
    }
    
    // Handling the card actions when panning
    private func performCardAction(with translation: CGPoint) {
        imageView.transform = cardGestureHandler.getTransformForTranslation(translation)
        imageView.alpha = cardGestureHandler.getAlphaForTranslation(translation)
    }
    
    // Applying color filter based on translation
    private func applyColorFilter() {
        let translationPoint = CGPoint(x: imageView.transform.tx, y: imageView.transform.ty)
        let color = colorFilterService.filterColorForTranslation(translationPoint)

        let colorFilter = UIView(frame: imageView.bounds)
        colorFilter.backgroundColor = color
        imageView.addSubview(colorFilter)
    }
    
    // Resetting the color filter
    private func resetColorFilter() {
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // Navigating to the result view controller with the card details
    private func navigateToResultViewController(with averagePrice: Double?, lowest: Double?, highest: Double?, currency: String, numberCardsSale: Int, cards: [ValuCards.ItemSummary]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultViewController = storyboard.instantiateViewController(withIdentifier: "Result") as? ResultViewController {
            resultViewController.averagePrice = averagePrice
            resultViewController.lowestPrice = lowest
            resultViewController.highestPrice = highest
            resultViewController.currency = currency
            resultViewController.image = imageView.image
            resultViewController.cardTitle = slideResponseModel.getCurrentTitle()
            resultViewController.cards = cards
            resultViewController.numberCardsSale = numberCardsSale
            navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}
