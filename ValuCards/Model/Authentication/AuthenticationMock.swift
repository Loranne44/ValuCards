//
//  AuthenticationMock.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 16/10/2023.
//

import Foundation
import UIKit
class AuthenticationMock: AuthenticationProtocol {

    var signInWithFirebaseError: ErrorCase?
    var signUpWithFirebaseError: ErrorCase?
    var signInWithGoogleError: ErrorCase?
    var logoutError: ErrorCase?

    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let errorCase = signInWithFirebaseError {
            completion(.failure(errorCase))
        } else {
            completion(.success(()))
        }
    }
    
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if let errorCase = signUpWithFirebaseError {
            completion(.failure(errorCase))
        } else {
            completion(.success(()))
        }
    }
    
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        if let errorCase = signInWithGoogleError {
            completion(.failure(errorCase))
        } else {
            completion(.success(()))
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        if let errorCase = logoutError {
            completion(.failure(errorCase))
        } else {
            completion(.success(()))
        }
    }
}
