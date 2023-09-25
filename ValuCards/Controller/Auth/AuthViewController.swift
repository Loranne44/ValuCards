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
        setupUIElements()
    }
    
    
    private func setupUIElements() {
        [signUpButton, signInButton, googleButton, appleButton, facebookButton].forEach {
            $0?.layer.cornerRadius = 15
        }
        passwordTextField.isSecureTextEntry = true
        setupViewsFor(pageType: .signIn)
    }
    
    private func setupViewsFor(pageType: PageType) {
        signInButton.isHidden = pageType == .signUp
        signUpButton.isHidden = pageType == .signIn
        forgetPasswordButton.isHidden = pageType == .signUp
    }
    
    // MARK: - IBActions
    @IBAction func forgetPasswordButtonTapped(_ sender: Any) {
        presentForgotPasswordAlert()
    }
    
    @IBAction func segmentedContolChanged(_ sender: UISegmentedControl) {
        currentPageType = sender.selectedSegmentIndex == 0 ? .signIn : .signUp
    }
    
    // Firebase authentication methods
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(for: .loginError)
            return
        }
        signInWithFirebase(email: email, password: password)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(for: .registrationError)
            return
        }
        signUpWithFirebase(email: email, password: password)
    }
    
    @IBAction func facebookAuthButton(_ sender: UIButton) {
        authenticateWithFacebook()
    }
    
    // MARK: - Firebase Authentication Methods
    private func signInWithFirebase(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (_, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    self?.showAlert(for: .firebaseLoginError)
                    return
                }
                self?.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: self)
            }
        }
    }
    
    private func signUpWithFirebase(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (_, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    self?.showAlert(for: .registrationError)
                    return
                }
                self?.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: self)
            }
        }
    }
    
    // MARK: - Firebase Helper Methods
    // Helper method for Firebase sign in with a given credential
    private func signInWithFirebaseCredential(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] (_, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    self?.showAlert(for: .loginError)
                    return
                }
                self?.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: self)
            }
        }
    }
    
    // MARK: - Facebook Authentication Method
    private func authenticateWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    self?.showAlert(for: .facebookLoginError)
                    return
                }
                
                guard let accessToken = AccessToken.current else {
                    self?.showAlert(for: .facebookLoginError)
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                self?.signInWithFirebaseCredential(credential)
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
                self.performSegue(withIdentifier: AuthViewController.searchCardsSegue, sender: self)
            }
        }
    }
    
    private func presentForgotPasswordAlert() {
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter your email address to receive a password reset link", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email Address"
            textField.keyboardType = .emailAddress
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { [weak self] (_) in
            guard let email = alertController.textFields?.first?.text else { return }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.showAlert(for: .invalidEmail)
                    } else {
                        self?.showAlert(for: .passwordResetSent)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
