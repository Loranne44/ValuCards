//
//  AuthenticationProtocol.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 16/10/2023.
//

import Foundation
import UIKit

protocol AuthenticationProtocol {
    func signInWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUpWithFirebase(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signInWithGoogle(presentingController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}
