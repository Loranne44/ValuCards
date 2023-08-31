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
    
    private var initialPanPoint: CGPoint = CGPoint.zero
    private let maxRotationAngle: CGFloat = CGFloat.pi / 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideResponseModel = ResponseModel(imagesAndTitlesAndPrices: imagesAndTitlesAndPrices)
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
            
            let translation = gesture.translation(in: imageView).x
            if translation > 0 {
                slideResponseModel?.showPreviousImage()
                navigateToResultViewController()
            } else {
                slideResponseModel?.showNextImage()
                // Mettre à jour l'image une fois l'animation terminée
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateImageAndTitle()
                    self.resetColorFilter()
                }
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
            colorFilter.backgroundColor = UIColor.green.withAlphaComponent(0.03)
        } else {
            // The gesture goes to the left, so apply a red filter
            colorFilter.backgroundColor = UIColor.red.withAlphaComponent(0.03)
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
            self.imageView.image = UIImage(named: "defaultImage") // Utilisez l'image par défaut si l'URL est invalide
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
                        self.imageView.image = UIImage(named: "defaultImage") // Utilisez l'image par défaut si l'image téléchargée est invalide
                    }
                }
            } catch {
                print("Erreur lors du téléchargement de l'image:", error)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(named: "defaultImage") // Utilisez l'image par défaut si une erreur se produit lors du téléchargement
                }
            }
        }
    }
    
    func navigateToResultViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultViewController = storyboard.instantiateViewController(withIdentifier: "Result") as? ResultViewController {
            resultViewController.priceValue = slideResponseModel.getCurrentPrice()
            //slideResponseModel.getCurrentPrice().value
            navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
    
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
        updateImageAndTitle()
    }
    
    @IBAction func validateImageButton(_ sender: UIButton) {
        navigateToResultViewController()
    }
    
    func performCardAction(with translation: CGPoint) {
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let translationPercent = translation.x / (UIScreen.main.bounds.width / 2)
        let rotationAngle = maxRotationAngle * translationPercent
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
        let transform = translationTransform.concatenating(rotationTransform)
        imageView.transform = transform
        
        let alphaPercent = abs(translationPercent)
        imageView.alpha = 1.0 - alphaPercent
    }
}

