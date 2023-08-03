//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit

class SlideViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrls: [String]!  // Ajouté pour stocker les URLs d'image
    var slideResponseModel: ResponseModel!
    
    private var initialPanPoint: CGPoint = CGPoint.zero
    private let maxRotationAngle: CGFloat = CGFloat.pi / 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slideResponseModel = ResponseModel(imageUrls: imageUrls)
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
                    self.updateImage()
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
            // Le geste va vers la droite, donc appliquer un filtre vert
            colorFilter.backgroundColor = UIColor.green.withAlphaComponent(0.03)
        } else {
            // Le geste va vers la gauche, donc appliquer un filtre rouge
            colorFilter.backgroundColor = UIColor.red.withAlphaComponent(0.03)
        }
        
        imageView.addSubview(colorFilter)
    }
    
    func resetColorFilter() {
        for subview in imageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func navigateToResultViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func updateImage() {
        let imageName = slideResponseModel.getCurrentImageName()
        imageView.image = UIImage(named: imageName)
    }
    
    @IBAction func nextImageButton(_ sender: UIButton) {
        slideResponseModel.showNextImage()
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

