//
//  ResultViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 19/07/2023.
//

import UIKit

class ResultViewController: UIViewController {
    var averagePrice: Double?
    var lowestPrice: Double?
    var highestPrice: Double?
    var currency: String?
    var image: UIImage?
    var numberCardsSale: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inconePriceTrendLowest: UILabel!
    @IBOutlet weak var iconePriceTrendAverage: UILabel!
    @IBOutlet weak var iconePriceTrendHighest: UILabel!
    @IBOutlet weak var lowestPriceLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var highestPriceLabel: UILabel!
    @IBOutlet weak var numberCardsSaleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let passedImage = image {
            imageView.image = passedImage
        }
        
        imageView.layer.cornerRadius = 30
        
        let currencySymbol = currency?.currencySymbol() ?? ""
        
        averagePriceLabel.text = averagePrice != nil ? String(format: "%.2f", averagePrice!) : "NB"
        lowestPriceLabel.text = lowestPrice != nil ? String(format: "%.2f", lowestPrice!) : "NB"
        highestPriceLabel.text = highestPrice != nil ? String(format: "%.2f", highestPrice!) : "NB"
        numberCardsSaleLabel.text = "\(numberCardsSale)"
        
        // numberCardsSale ->  fonctionner par palier : Only 1, 5 or more, 10 or more / 25 or more/ 50 or more/ 100 or more/ 200 or more / 300 or more
        
        inconePriceTrendLowest.text = currencySymbol
        iconePriceTrendAverage.text = currencySymbol
        iconePriceTrendHighest.text = currencySymbol
    }
}
