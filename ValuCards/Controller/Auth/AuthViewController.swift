//
//  AuthViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

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
    
    private enum PageType {
        case signIn
        case signUp
    }
    
    private var currentPageType: PageType = .signIn {
        didSet {
            setupViewsFor(pageType: currentPageType)
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            navigateToSearchCardViewController()
        }
    }
    
    // MARK: - UI Setup
    private func setupUIElements() {
        [signUpButton, signInButton, googleButton].forEach {
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
        
        AuthManager.shared.signInWithFirebase(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigateToSearchCardViewController()
                case .failure:
                    self?.showAlert(for: .firebaseLoginError)
                }
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(for: .registrationError)
            return
        }
        AuthManager.shared.signUpWithFirebase(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigateToSearchCardViewController()
                case .failure:
                    self?.showAlert(for: .registrationError)
                }
            }
        }
    }
    
    // MARK: - Google Authentication Method
    @IBAction func googleAuthButton(_ sender: UIButton) {
        AuthManager.shared.signInWithGoogle(presentingController: self) { [weak self] result in
            switch result {
            case .success:
                self?.navigateToSearchCardViewController()
            case .failure:
                self?.showAlert(for: .loginError)
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
    
    private func navigateToSearchCardViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController,
           let searchCardViewController = storyboard.instantiateViewController(withIdentifier: "searchViewControllerID") as? SearchCardViewController {
            
            navigationController.setViewControllers([searchCardViewController], animated: false)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
