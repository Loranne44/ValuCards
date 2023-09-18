//
//  AuthViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FacebookLogin
import GoogleSignIn
import AuthenticationServices

class AuthViewController: UIViewController {
    
    static let searchCardsSegue = "SearchCards"
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    // Enum to differentiate between sign in and sign up page
    private enum PageType {
        case signIn
        case signUp
    }
    
    // Current displayed page
    private var currentPageType: PageType = .signIn {
        didSet {
            setupViewsFor(pageType: currentPageType)
        }
    }
    
    // Add this property to store nonce for Apple Sign In
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
        }
        
        // Setup UI elements
        signUpButton.layer.cornerRadius = 15
        signInButton.layer.cornerRadius = 15
        googleButton.layer.cornerRadius = 15
        appleButton.layer.cornerRadius = 15
        facebookButton.layer.cornerRadius = 15
        
        passwordTextField.isSecureTextEntry = true
        setupViewsFor(pageType: .signIn)
        
    }
    
    // Method to setup views based on the current page type
    private func setupViewsFor(pageType: PageType) {
        signInButton.isHidden = pageType == .signUp
        signUpButton.isHidden = pageType == .signIn
        forgetPasswordButton.isHidden = pageType == .signUp
    }
    
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter your email address to receive a password reset link", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email Address"
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let email = alertController.textFields?.first?.text else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil {
                    self.showAlert(for: .invalidEmail)
                } else {
                    self.showAlert(for: .passwordResetSent)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func segmentedContolChanged(_ sender: UISegmentedControl) {
        if sender.titleForSegment(at: sender.selectedSegmentIndex) == "Sign In" {
            currentPageType = .signIn
        } else {
            currentPageType = .signUp
        }
    }
    
    // Firebase authentication methods
    @IBAction func signInButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        signInWithFirebase(email: email, password: password)
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        signUpWithFirebase(email: email, password: password)
    }
    
    @IBAction func facebookAuthButton(_ sender: UIButton) {
        authenticateWithFacebook()
    }
    
    // Facebook authentication method
    private func signInWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (_, error) in
            guard let self = self else { return }
            if error != nil {
                self.showAlert(for: .loginError)
            } else {
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
            }
        }
    }
    
    private func signUpWithFirebase(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (_, error) in
            guard let self = self else { return }
            if error != nil {
                self.showAlert(for: .loginError)
            } else {
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
            }
        }
    }
    
    private func authenticateWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
            guard let self = self else { return }
            if error != nil {
                self.showAlert(for: .loginError)
                return
            }
            
            // Après un login Facebook réussi, récupérez le jeton d'accès
            guard let accessToken = AccessToken.current else {
                self.showAlert(for: .loginError)
                return
            }
            
            // Échangez ce jeton d'accès contre un identifiant Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }
                if error != nil {
                    self.showAlert(for: .loginError)
                    return
                }
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
            }
        }
    }
    
    @IBAction func googleAuthButton(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                // Handle the error
                self.showAlert(for: .loginError)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                // Handle the error
                self.showAlert(for: .loginError)
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let self = self else { return }
                if error != nil {
                    self.showAlert(for: .loginError)
                    return
                }
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
            }
        }
    }
}
