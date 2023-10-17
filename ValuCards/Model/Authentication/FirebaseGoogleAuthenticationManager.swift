//
//  FirebaseGoogleAuthenticationManager.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

class FirebaseGoogleAuthenticationManager: AuthenticationProtocol {
    
    static let shared = FirebaseGoogleAuthenticationManager()
    private init() {}
    
    // MARK: - Firebase Authentication
    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Google Authentication
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "FirebaseGoogleAuthenticationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Client ID missing"])))
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "FirebaseGoogleAuthenticationManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Auth failed"])))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { (_, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
