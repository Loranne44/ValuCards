//
//  AuthViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import FirebaseAuth
import FacebookLogin

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
        forgetPasswordButton.isHidden = pageType == .signUp
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func segmentedContolChanged(_ sender: UISegmentedControl) {
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "Sign In" {
            currentPageType = .signIn
        } else {
            currentPageType = .signUp
        }
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.showAlert(for: .erreurConnexion)
            } else {
                strongSelf.showSuccessPopup(for: .connexionReussi)
            }
        }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.showAlert(for: .erreurInscription)
            } else {
                strongSelf.showSuccessPopup(for: .inscriptionReussi, segueIdentifier: "SearchCards")
            }
        }
    }
    
    @IBAction func facebookAuthButton(_ sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.showAlert(for: .erreurConnexionFb)
                return
            }
            
            if let token = AccessToken.current, !token.isExpired {
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                // Connexion à Firebase avec Facebook
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        strongSelf.showAlert(for: .erreurConnexionFirebase)
                    } else {
                        let userID = authResult?.user.uid ?? ""
                        let message = "Connexion via Facebook réussie ! UserID : \(userID)"
                        strongSelf.showSuccessPopup(for: .customMessage(message), segueIdentifier: "SearchCards")
                    }
                }
            }
        }
    }
}
// PAgeViewController


