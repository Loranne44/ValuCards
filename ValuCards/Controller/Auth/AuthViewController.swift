//
//  AuthViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    private enum PageType {
        case signIn
        case signUp
    }
    
    private var currentPageType: PageType = .signIn {
        didSet {
            setupViewsFor(pageType: currentPageType)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Custom Button
        signUpButton.layer.cornerRadius = 15
        signInButton.layer.cornerRadius = 15
        googleButton.layer.cornerRadius = 15
        appleButton.layer.cornerRadius = 15
        facebookButton.layer.cornerRadius = 15

        setupViewsFor(pageType: .signIn)
    }
    
    private func setupViewsFor(pageType: PageType) {
        signInButton.isHidden = pageType == .signUp
        signUpButton.isHidden = pageType == .signIn
        forgetPasswordButton.isHidden = pageType == .signIn
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func segmentedContolChanged(_ sender: UISegmentedControl) {
        currentPageType = sender.selectedSegmentIndex == 0 ? .signIn : .signUp
        
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                   return
               }
               
               Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
                   guard let strongSelf = self else { return }
                   
                   if let error = error {
                       print("Erreur lors de l'inscription : \(error.localizedDescription)")
                   } else {
                       // Inscription réussie, vous pouvez effectuer des actions supplémentaires ici
                       strongSelf.performSegue(withIdentifier: "SearchCards", sender: nil)
                }
            }
        }
    
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                    guard let strongSelf = self else { return }
                    
                    if let error = error {
                        print("Erreur lors de la connexion : \(error.localizedDescription)")
                    } else {
                        // Connexion réussie, vous pouvez effectuer des actions supplémentaires ici
                        strongSelf.performSegue(withIdentifier: "loginSuccessSegue", sender: nil)
                }
            }
        }
    
    
    
}


// PAgeViewController
