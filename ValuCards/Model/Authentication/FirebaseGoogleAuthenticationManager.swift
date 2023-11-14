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
import FirebasePerformance

class FirebaseGoogleAuthenticationManager: AuthenticationProtocol {
    
    static let shared = FirebaseGoogleAuthenticationManager()
    private init() {}
    
    // MARK: - Firebase Authentication
    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let trace = Performance.startTrace(name: "signin_with_firebase_email")

        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            trace?.stop()

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let trace = Performance.startTrace(name: "signup_with_firebase_email")

        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            trace?.stop()

            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Google Authentication
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        let trace = Performance.startTrace(name: "signin_with_google")

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
                trace?.stop()

                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        let trace = Performance.startTrace(name: "logout")

        do {
            try Auth.auth().signOut()
            trace?.stop()
            completion(.success(()))
        } catch {
            trace?.stop()
            completion(.failure(error))
        }
    }
}
