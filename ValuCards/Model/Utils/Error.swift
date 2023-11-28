//
//  Error.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 29/06/2023.
//

import Foundation

enum ErrorCase: Error {
    // Network related errors
        case invalidURL
        case serverError
        case generalNetworkError
        case requestFailed
        case resourceNotFound
        case jsonDecodingError
        
        // User related errors
        case registrationError
        case loginError
        case firebaseLoginError
        case passwordResetSent
        case invalidEmail
        case signOutError
        
        // App specific errors
        case noCardsFound
        case cardNameMissing
        case otherCardMissing
        case cardSearchError
        case countryNotSelected
        case imageDownloadError
        case gifLoadingError
    
    // Message
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check and try again"
        case .jsonDecodingError:
            return "Data processing error. Try again later"
        case .noCardsFound:
            return "No matching cards found. Check spelling or try another name"
        case .registrationError:
            return "Registration failed. Check your information"
        case .loginError:
            return "Login failed. Check your credentials"
        case .serverError:
            return "Server issue. Please retry later"
        case .generalNetworkError:
            return "Network issue. Check your connection"
        case .firebaseLoginError:
            return "Firebase login issue. Retry later"
        case .requestFailed:
            return "Request error. Please retry"
        case .cardNameMissing:
            return "Enter a card name to search"
        case .otherCardMissing:
            return "Card not found. Check spelling or try another"
        case .cardSearchError:
            return "Failed to retrieve card details. Please try again"
        case .passwordResetSent:
            return "Password reset link sent. Check your email"
        case .invalidEmail:
            return "Invalid email. Please retry"
        case .countryNotSelected:
            return "Country not chosen. Please select one"
        case .resourceNotFound:
            return "Requested resource not found. Please check and try again"
        case .signOutError:
            return "There was an issue logging out. Please try again"
        case .imageDownloadError:
            return "Failed to download the card image. Using a default image instead"
        case .gifLoadingError:
            return "Failed to load the loading GIF. Please report this error"
        }
    }
}


// Une des pistes d'amélioration : gérer la traduction
