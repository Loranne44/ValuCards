//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var cardModel = CardModel()
    
    private var initialPanPoint: CGPoint = CGPoint.zero
    private let maxRotationAngle: CGFloat = CGFloat.pi / 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        imageView.addGestureRecognizer(panGesture)
        
        // Ajouter une ombre à l'image
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 4.0
        
        // Afficher la première image au lancement de l'application
        updateImage()
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            initialPanPoint = gesture.translation(in: imageView)
        case .changed:
            performCardAction(with: gesture.translation(in: imageView))
        case .ended, .cancelled:
            imageView.alpha = 1.0
            UIView.animate(withDuration: 0.3) {
                self.imageView.transform = .identity
            }
            
            let translation = gesture.translation(in: imageView).x
            if translation > 0 {
                cardModel.showPreviousImage()
                navigateToResultViewController()
            } else {
                cardModel.showNextImage()
            }
            
            updateImage()
            
        default:
            break
        }
    }
    
    func navigateToResultViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func updateImage() {
        let imageName = cardModel.getCurrentImageName()
        imageView.image = UIImage(named: imageName)
    }
    
    @IBAction func nextImageButton(_ sender: UIButton) {
        cardModel.showNextImage()
        updateImage()
        
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

