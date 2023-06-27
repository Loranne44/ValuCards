//
//  ManualSearchViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import UIKit

class ManualSearchViewController: UIViewController {
    
    @IBOutlet weak var SearchCardNameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Search Button
        SearchCardNameButton.layer.cornerRadius = 15
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
