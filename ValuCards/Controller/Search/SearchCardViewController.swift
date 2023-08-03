//
//  CardsScannViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation


class SearchCardViewController: UIViewController {
    
    @IBOutlet weak var CardNameTextField: UITextField!
    @IBOutlet weak var SearchManuelCardButton: UIButton!
    
    var imageUrlsToSend: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchManuelCardButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        search()
    }
    
    func search() {
        guard let name = CardNameTextField.text, !name.isEmpty else {
            // MESSAGE D'ERREUR pour indiquer que ca ne peut pas etre vide
            return
        }
        
        CardsModel.shared.searchCards(withName: "pikachu") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(card):
                    print(card)
                    let imageUrls = card.itemSummaries.flatMap { $0.thumbnailImages.map { $0.imageUrl } }
                    
                    // Stocker les URLs d'image de manière à ce qu'elles puissent être passées au SlideViewController
                    self.imageUrlsToSend = imageUrls
                    
                    // Effectuer la transition en utilisant le segue
                    self.performSegue(withIdentifier: "SlideViewController", sender: self)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideViewController",
           let slideViewController = segue.destination as? SlideViewController {
            slideViewController.imageUrls = imageUrlsToSend
        }
    }
}
