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
    @IBOutlet weak var containerDescription: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerCheckOrCancel: UIView!
    
    // MARK: - Properties
    let colorOverlay = UIView()
    var imagesAndTitles: [(imageName: String, title: String)] = []
    var slideResponseModel: ResponseModel!
    let pricingService = CardPricingService()
    var totalCardCount: Int?
    var selectedCountry: EbayCountry?
    
    // Gesture and image services
    private let cardGestureHandler = CardGestureHandler()
    private let imageService = ImageService()
    private let colorFilterService = ColorFilterService()
    private var initialPanPoint: CGPoint = CGPoint.zero
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()        
        setupContainerDescription()
        setupContainerCheckOrCancel()
        setupGestureRecognizers()
        prepareDataModel()
        updateImageAndTitle()
        setupColorOverlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetColorFilter()
    }
    
    // MARK: - Setup Methods
    private func setupColorOverlay() {
        colorOverlay.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(colorOverlay)
        NSLayoutConstraint.activate([
            colorOverlay.topAnchor.constraint(equalTo: imageView.topAnchor),
            colorOverlay.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            colorOverlay.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            colorOverlay.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        colorOverlay.backgroundColor = .clear
    }
    
    private func setupContainerDescription() {
        ViewHelper.applyShadowAndRoundedCorners(to: containerDescription, shadowPosition: .bottom)
    }
    
    private func setupContainerCheckOrCancel() {
        ViewHelper.applyShadowAndRoundedCorners(to: containerCheckOrCancel, shadowPosition: .top)
    }
    
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        imageView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Data Preparation
    private func prepareDataModel() {
        // Process the raw data and initialize the model used in this view controller
        let cardItems = imagesAndTitles.map { CardItem(imageName: $0.imageName, title: $0.title) }
        slideResponseModel = ResponseModel(cardItems: cardItems)
        totalCardCount = slideResponseModel.cardItems.count
    }
    
    // MARK: - Gesture Handling
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        // Handle user’s pan gesture and update the UI accordingly
        switch gesture.state {
        case .began:
            initialPanPoint = gesture.translation(in: imageView)
        case .changed:
            updateCardTransform(with: gesture.translation(in: imageView))
            applyColorFilter()
        case .ended, .cancelled:
            imageView.alpha = 1.0
            UIView.animate(withDuration: 0.6) {
                self.imageView.transform = .identity
            }
            
            let translationX = gesture.translation(in: imageView).x
            if translationX > 0 {
                navigateToResultViewController(with: slideResponseModel.getCurrentTitle(), image: imageView.image)
            } else {
                slideResponseModel.showNextImage()
                updateImageAndTitle()
                resetColorFilter()
            }
        default:
            break
        }
    }
    
    // MARK: - Actions
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
        updateImageAndTitle()
    }
    
    @IBAction func validateImageButton(_ sender: UIButton) {
        navigateToResultViewController(with: slideResponseModel.getCurrentTitle(), image: imageView.image)
    }
    
    func updateImageAndTitle() {
        let imageUrlString = slideResponseModel.getCurrentImageName()
        var title = slideResponseModel.getCurrentTitle()
            
        if title.isEmpty {
            title = "NB"
        }
        titleLabel.text = title
            
        imageService.downloadImage(from: imageUrlString) { [weak self] image in
            DispatchQueue.main.async {
                if let validImage = image {
                    self?.imageView.image = validImage
                } else {
                    self?.imageView.image = UIImage(named: "defaultImage")
                    self?.showAlert(for: .imageDownloadError)
                }
            }
        }
    }
    
    private func updateCardTransform(with translation: CGPoint) {
        imageView.transform = cardGestureHandler.getTransformForTranslation(translation)
        imageView.alpha = cardGestureHandler.getAlphaForTranslation(translation)
    }
    
    private func applyColorFilter() {
        let translationPoint = CGPoint(x: imageView.transform.tx, y: imageView.transform.ty)
        let color = colorFilterService.filterColorForTranslation(translationPoint)
        colorOverlay.backgroundColor = color
    }
    
    private func resetColorFilter() {
        colorOverlay.backgroundColor = .clear
    }
    
    // MARK: - Navigation
    private func navigateToResultViewController(with cardTitle: String, image: UIImage?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultViewController = storyboard.instantiateViewController(withIdentifier: "ResultViewControllerID") as? ResultViewController,
           let loadingVC = storyboard.instantiateViewController(withIdentifier: "LoadingViewControllerID") as? LoadingViewController {
            loadingVC.modalPresentationStyle = .overFullScreen
            self.present(loadingVC, animated: true, completion: nil)
            
            resultViewController.cardTitle = cardTitle
            resultViewController.image = image
            resultViewController.selectedCountry = self.selectedCountry
            resultViewController.loadingViewController = loadingVC
            self.navigationController?.pushViewController(resultViewController, animated: false)
            
            /*  // Load data then navigate to ResultViewController
             resultViewController.fetchCardDetails { [weak self] in
                 self?.navigationController?.pushViewController(resultViewController, animated: false)
             }*/
        }
    }
    
}

