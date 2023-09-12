//
//  SuccessCase.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 05/09/2023.
//

import Foundation

enum SuccessCase {
    case cardAddedSuccessfully
    case cardUpdatedSuccessfully
    case registrationSuccessful
    case loginSuccessful
    case facebookLoginSuccessful
    case firebaseLoginSuccessful
    case customMessage(String)
    
    var message: String {
        switch self {
        case .cardAddedSuccessfully:
            return "Card added successfully."
        case .cardUpdatedSuccessfully:
            return "Card updated successfully."
        case .registrationSuccessful:
            return "Registration successful!"
        case .loginSuccessful:
            return "Login successful!"
        case .facebookLoginSuccessful:
            return "Logged in successfully via Facebook!"
        case .firebaseLoginSuccessful:
            return "Logged in successfully via Firebase!"
        case .customMessage(let customMsg):
            return customMsg
        }
    }
}
