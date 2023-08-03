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
                    
                    // Créer une instance de SlideViewController et passer les URLs
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let slideViewController = storyboard.instantiateViewController(withIdentifier: "SlideViewController") as? SlideViewController {
                        // Remplacez "SlideViewController" par l'identifiant de votre vue controller dans le storyboard
                        slideViewController.imageUrls = imageUrls
                        self.navigationController?.pushViewController(slideViewController, animated: true)
                    }
                    print(card)
                    
                case let .failure(error):
                    print(error)
                }
            }
            
        }
    }
    
}
