//
//  Error.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation

enum ErrorCase: Error {
    case invalidURL
    case jsonDecodingError(error: Error)
    case noCardsFound
    case requestFailed(error: Error)
    case generalNetworkError
    case serverError
    case registrationError
    case loginError
    case facebookLoginError
    case firebaseLoginError
    case cardNameMissing
    case otherCardMissing
    case cardSearchError
    case imageConnectionError
    case passwordResetSent
    case invalidEmail
    case paysNonSelectionnée
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Error creating URL. Check the query string."
        case .jsonDecodingError(let error):
            return "JSON decoding error: \(error.localizedDescription)"
        case .noCardsFound:
            return "No cards matching your search were found. Try with a different card name or check the spelling."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .generalNetworkError:
            return "A network error occurred. Please try again."
        case .serverError:
            return "A server error occurred. Please try again later."
        case .registrationError:
            return "Registration error"
        case .loginError:
            return "Login error"
        case .facebookLoginError:
            return "Error logging in via Facebook"
        case .firebaseLoginError:
            return "Error logging in via Firebase"
        case .cardNameMissing:
            return "Please enter the name of the card you wish to search for."
        case .otherCardMissing:
            return "Unable to find the requested card. Please check the name spelling or try a different search."
        case .cardSearchError:
            return "An error occurred while searching for the card. Please try again."
        case .imageConnectionError:
            return "Unable to download the image. Please check your connection and try again."
        case .passwordResetSent:
            return "A password reset link has been sent to your email address. Please check your inbox."
        case .invalidEmail:
            return "Invalid or non-existent email."
        case .paysNonSelectionnée:
            return "Pays non sélectionné. Veuillez choisir un pays"
        }
    }
}
