//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit
import FirebasePerformance

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
    
    /// Gesture and image services
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
    /// Sets up a color overlay on the image view
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
    
    /// Applies shadow and rounded corners to the description container
    private func setupContainerDescription() {
        ViewHelper.applyShadowAndRoundedCorners(to: containerDescription, shadowPosition: .bottom)
    }
    
    /// Applies shadow and rounded corners to the check or cancel container
    private func setupContainerCheckOrCancel() {
        ViewHelper.applyShadowAndRoundedCorners(to: containerCheckOrCancel, shadowPosition: .top)
    }
    
    /// Sets up gesture recognizers for card interaction
    private func setupGestureRecognizers() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        imageView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Data Preparation
    /// Prepares data model for card items
    private func prepareDataModel() {
        let cardItems = imagesAndTitles.map { CardItem(imageName: $0.imageName, title: $0.title) }
        slideResponseModel = ResponseModel(cardItems: cardItems)
        totalCardCount = slideResponseModel.cardItems.count
    }
    
    // MARK: - Gesture Handling
    /// Handles user gestures on the card (panning)
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
    /// Action for navigating to the next image
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
        updateImageAndTitle()
    }
    
    /// Action for validating the current image
    @IBAction func validateImageButton(_ sender: UIButton) {
        navigateToResultViewController(with: slideResponseModel.getCurrentTitle(), image: imageView.image)
    }
    
    /// Updates the displayed image and its title
    func updateImageAndTitle() {
        let trace = Performance.startTrace(name: "image_download")
        let imageUrlString = slideResponseModel.getCurrentImageName()
        var title = slideResponseModel.getCurrentTitle()
            
        if title.isEmpty {
            title = "NB"
        }
        titleLabel.text = title
            
        imageService.downloadImage(from: imageUrlString) { [weak self] image in
            trace?.stop()
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
    
    /// Updates the card transform based on the translation of a pan gesture
    private func updateCardTransform(with translation: CGPoint) {
        imageView.transform = cardGestureHandler.getTransformForTranslation(translation)
        imageView.alpha = cardGestureHandler.getAlphaForTranslation(translation)
    }
    
    /// Applies a color filter based on the card's translation
    private func applyColorFilter() {
        let translationPoint = CGPoint(x: imageView.transform.tx, y: imageView.transform.ty)
        let color = colorFilterService.filterColorForTranslation(translationPoint)
        colorOverlay.backgroundColor = color
    }
    
    /// Resets the color filter to clear
    private func resetColorFilter() {
        colorOverlay.backgroundColor = .clear
    }
    
    // MARK: - Navigation
    /// Navigates to the result view controller with the selected card details
    private func navigateToResultViewController(with cardTitle: String, image: UIImage?) {
        let trace = Performance.startTrace(name: "navigate_to_result_view")

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
            trace?.stop()

        }
    }
    
}

