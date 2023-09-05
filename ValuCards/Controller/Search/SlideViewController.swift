//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit

class SlideViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var imagesAndTitlesAndPrices: [(imageName: String, title: String, price: Price)] = []
    
    var slideResponseModel: ResponseModel!
    let pricingService = CardPricingService()
    var numberCardsSale: Int?
    
    private var initialPanPoint: CGPoint = CGPoint.zero
    private let maxRotationAngle: CGFloat = CGFloat.pi / 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 30
            imageView.layer.masksToBounds = true
                
            let cardItems = imagesAndTitlesAndPrices.map { CardItem(imageName: $0.imageName, title: $0.title, price: $0.price) }
                
            slideResponseModel = ResponseModel(cardItems: cardItems)
            imageView.isUserInteractionEnabled = true
                
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            imageView.addGestureRecognizer(panGesture)
                
            // Ajouter une ombre à l'image
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
            imageView.layer.shadowOpacity = 0.8
            imageView.layer.shadowRadius = 4.0
                
            updateImageAndTitle()
    }
    
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
            let currentTitle = slideResponseModel.getCurrentTitle()
            
            if translationX > 0 {
                CardsModel.shared.searchCards(withName: currentTitle) { [weak self] result in
                    
                    switch result {
                    case let .success(card):
                        guard let strongSelf = self else { return }
                        let averagePrice = strongSelf.pricingService.getAveragePrice(from: card.itemSummaries)
                        let lowestPrice = strongSelf.pricingService.getLowestPrice(from: card.itemSummaries)
                        let highestPrice = strongSelf.pricingService.getHighestPrice(from: card.itemSummaries)
                        if let currency = card.itemSummaries.first?.price.currency {
                            self?.navigateToResultViewController(with: averagePrice, lowest: lowestPrice, highest: highestPrice, currency: currency)
                        }
                    case .failure(_):
                        self?.showAlert(for: .rechercheCarte)
                    }
                }
            } else {
                slideResponseModel.showNextImage()
                updateImageAndTitle()
                resetColorFilter()
            }
            
        default:
            break
        }
    }
    
    func applyColorFilter() {
        let colorFilter = UIView()
        colorFilter.frame = imageView.bounds
        
        let translation = imageView.transform.tx
        if translation > 0 {
            // The gesture goes to the right, so apply a green filter
            colorFilter.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        } else {
            // The gesture goes to the left, so apply a red filter
            colorFilter.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        
        imageView.addSubview(colorFilter)
    }
    
    func resetColorFilter() {
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func updateImageAndTitle() {
        let imageUrlString = slideResponseModel.getCurrentImageName()
        var title = slideResponseModel.getCurrentTitle()
        if title.isEmpty {
            title = "NB"
        }
        titleLabel.text = title
        
        guard let imageUrl = URL(string: imageUrlString) else {
            self.imageView.image = UIImage(named: "defaultImage")
            return
        }
        // Download background image
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageUrl)
                
                // Mettre à jour l'image dans le thread principal
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageView.image = image
                    } else {
                        self.imageView.image = UIImage(named: "defaultImage")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "defaultImage")
                    self.showAlert(for: .connexionInternetImage)
                }
            }
        }
    }
    
    func navigateToResultViewController(with averagePrice: Double, lowest: Double, highest: Double, currency: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultViewController = storyboard.instantiateViewController(withIdentifier: "Result") as? ResultViewController {
            resultViewController.averagePrice = averagePrice
            resultViewController.lowestPrice = lowest
            resultViewController.highestPrice = highest
            resultViewController.currency = currency
            resultViewController.numberCardsSale = slideResponseModel.cardItems.count
            resultViewController.image = imageView.image
            navigationController?.pushViewController(resultViewController, animated: true)
        }    }
    
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
        updateImageAndTitle()
    }
    
    @IBAction func validateImageButton(_ sender: UIButton) {
        let currentTitle = slideResponseModel.getCurrentTitle()
        CardsModel.shared.searchCards(withName: currentTitle) { [weak self] result in
            switch result {
            case let .success(card):
                guard let strongSelf = self else { return }
                let averagePrice = strongSelf.pricingService.getAveragePrice(from: card.itemSummaries)
                let lowestPrice = strongSelf.pricingService.getLowestPrice(from: card.itemSummaries)
                let highestPrice = strongSelf.pricingService.getHighestPrice(from: card.itemSummaries)
                if let currency = card.itemSummaries.first?.price.currency {
                    self?.navigateToResultViewController(with: averagePrice, lowest: lowestPrice, highest: highestPrice, currency: currency)
                }
            case .failure(_):
                self?.showAlert(for: .rechercheCarte)
            }
        }
    }
    
    func performCardAction(with translation: CGPoint) {
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationPercent = translation.x / (UIScreen.main.bounds.width / 2)
        let rotationAngle = maxRotationAngle * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationTransform)
        imageView.transform = transform
        
        let alphaPercent = min(abs(translationPercent) * 2, 1.0)
        imageView.alpha = 1.0 - alphaPercent
    }
}
