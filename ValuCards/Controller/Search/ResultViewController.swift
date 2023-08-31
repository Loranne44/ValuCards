//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit

class ResultViewController: UIViewController {
    var priceValue: Price?

    @IBOutlet weak var priceActual: UILabel!
    @IBOutlet weak var priceTrendLabel: UILabel!
    @IBOutlet weak var iconePriceTrend: UIImageView!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var saleNumberPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let priceValue = priceValue {
                priceActual.text = formattedPrice(for: priceValue)
            } else {
                priceActual.text = "NB"
            }
    }
}
