//
//  ViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var CreateNewAccountButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Sign In Button
        SignInButton.layer.cornerRadius = 15
        
        //Create New Account Button
        CreateNewAccountButton.layer.cornerRadius = 15
    }


}

