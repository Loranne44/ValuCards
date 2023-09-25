//
//  LoadingViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 25/09/2023.
//

import UIKit
import SDWebImage

class LoadingViewController: UIViewController {
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        loadGif()
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func loadGif() {
        if let url = Bundle.main.url(forResource: "gifloader", withExtension: "gif") {
            imageView.sd_setImage(with: url)
        } else {
            print("Erreur: URL du GIF est nil")
        }
    }
}
