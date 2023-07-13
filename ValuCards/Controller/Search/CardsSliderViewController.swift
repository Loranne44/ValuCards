//
//  CardSliderViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 13/07/2023.
//

import UIKit
import CardSlider

struct Item: CardSliderItem {
    var image: UIImage
    var rating: Int?
    var title: String
    var subtitle: String?
    var description: String?
}

class CardsSliderViewController: UIViewController, CardSliderDataSource {
    
    var data = [Item]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Present the card slider
        let vc = CardSliderViewController.with(dataSource: self)
        vc.title = "Select the corresponding card"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Faire une boucle for avec des range 1...100
        
        for i in 1...10 {
            data.append(Item(image: (UIImage(named: "pika")!), title: ""))
        }
    }
    
    func item(for index: Int) -> CardSlider.CardSliderItem {
        return data[index]
    }
    
    func numberOfItems() -> Int {
        return data.count
    }
}
