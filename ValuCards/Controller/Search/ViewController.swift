//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var imageNames: [String] = ["AA", "BB", "CC"]
    var imageViews: [UIImageView] = []
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Créez une UIScrollView pour afficher les images.
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(imageNames.count), height: view.bounds.height)
        view.addSubview(scrollView)

        // Ajoutez les images à la UIScrollView.
        for i in 0..<imageNames.count {
            let imageView = UIImageView(image: UIImage(named: imageNames[i]))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = CGRect(x: CGFloat(i) * view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
            scrollView.addSubview(imageView)
            imageViews.append(imageView)
        }

        // Ajoutez un geste de balayage vers la gauche.
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        // Ajoutez un geste de balayage vers la droite.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }

    // Méthode pour gérer le geste de balayage vers la gauche.
    @objc func handleSwipeLeft() {
        if currentIndex < imageViews.count - 1 {
            currentIndex += 1
            let offsetX = CGFloat(currentIndex) * view.bounds.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }

    // Méthode pour gérer le geste de balayage vers la droite.
    @objc func handleSwipeRight() {
        if currentIndex > 0 {
            currentIndex -= 1
            let offsetX = CGFloat(currentIndex) * view.bounds.width
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}
