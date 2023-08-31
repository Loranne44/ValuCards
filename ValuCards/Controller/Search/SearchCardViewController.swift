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
    
    var imagesAndTitlesAndPricesToSend: [(imageName: String, title: String, price: Price)] = []

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
        
        CardsModel.shared.searchCards(withName: name) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(card):
                    print(card)
                    let imagesAndTitlesAndPrices = card.itemSummaries.flatMap { summary in
                        summary.thumbnailImages.map { image in
                            (imageName: image.imageUrl, title: summary.title, price: summary.price)
                        }
                    }
                    
                    // store image urls and prices to be passed to SlideViewController
                    self.imagesAndTitlesAndPricesToSend = imagesAndTitlesAndPrices
                    self.performSegue(withIdentifier: "SlideViewControllerSegue", sender: self)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideViewControllerSegue",
           let slideViewController = segue.destination as? SlideViewController {
            slideViewController.imagesAndTitlesAndPrices = imagesAndTitlesAndPricesToSend
        }
    }
}
