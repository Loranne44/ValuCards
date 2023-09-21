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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateIfLoggedIn()
        setupUIElements()
    }
    
    // If user is logged in, navigate to search cards
    private func navigateIfLoggedIn() {
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: nil)
            }
        }
    }
    
    private func setupUIElements() {
        [signUpButton, signInButton, googleButton, appleButton, facebookButton].forEach {
                   $0?.layer.cornerRadius = 15
               }
               
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
        currentPageType = sender.selectedSegmentIndex == 0 ? .signIn : .signUp
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
                   if let error = error {
                       self?.showAlert(for: .loginError)
                       print("Error during sign in: \(error.localizedDescription)")
                       return
                   }
                   self?.navigateIfLoggedIn()
               }
    }
    
    private func signUpWithFirebase(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (_, error) in
                    if let error = error {
                        self?.showAlert(for: .loginError)
                        print("Error during sign up: \(error.localizedDescription)")
                        return
                    }
                    self?.navigateIfLoggedIn()
                }
    }
    
    // MARK: - Facebook Authentication Method
    private func authenticateWithFacebook() {
        let loginManager = LoginManager()
               loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
                   if let error = error {
                       self?.showAlert(for: .loginError)
                       print("Facebook login error: \(error.localizedDescription)")
                       return
                   }
                   
                   guard let accessToken = AccessToken.current else {
                       self?.showAlert(for: .loginError)
                       return
                   }
                   
                   let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                   
                   Auth.auth().signIn(with: credential) { [weak self] (_, error) in
                       if let error = error {
                           self?.showAlert(for: .loginError)
                           print("Error signing in with Facebook: \(error.localizedDescription)")
                           return
                       }
                       self?.navigateIfLoggedIn()
                   }
               }
    }
    
    // MARK: - Google Authentication Method
    @IBAction func googleAuthButton(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                self.showAlert(for: .loginError)
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
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
                self.navigateIfLoggedIn()
            }
        }
    }
}
