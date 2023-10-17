//
//  AuthenticationMock.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 16/10/2023.
//

import Foundation
import UIKit

class AuthenticationMock: AuthenticationProtocol {
    var signInWithFirebaseResult: Result<Void, Error>?
    var signUpWithFirebaseResult: Result<Void, Error>?
    var signInWithGoogleResult: Result<Void, Error>?
    var logoutResult: Result<Void, Error>?
    
    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = signInWithFirebaseResult {
            completion(result)
        }
    }
    
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = signUpWithFirebaseResult {
            completion(result)
        }
    }
    
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = signInWithGoogleResult {
            completion(result)
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        if let result = logoutResult {
            completion(result)
        }
    }
}
