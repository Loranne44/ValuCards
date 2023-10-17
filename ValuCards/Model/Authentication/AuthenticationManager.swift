//
//  AuthenticationManager.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 12/10/2023.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthenticationManager: AuthenticationProtocol {
    static let shared = AuthenticationManager()
    
    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // This should be implemented or can be left empty if not used.
    }
    
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // This should be implemented or can be left empty if not used.
    }
    
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        // This should be implemented or can be left empty if not used.
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
