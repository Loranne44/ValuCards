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
    case erreurInscription
    case erreurConnexion
    case erreurConnexionFb
    case erreurConnexionFirebase
    case nomCarteManquante
    case autreCarteManquante
    case rechercheCarte
    case connexionInternetImage
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Erreur de création d'URL. Vérifiez la chaîne de requête."
        case .jsonDecodingError(let error):
            return "Erreur de décodage JSON: \(error.localizedDescription)"
        case .noCardsFound:
            return "Aucune carte correspondant à votre recherche n'a été trouvée. Essayez avec un autre nom de carte ou vérifiez l'orthographe"
        case .requestFailed(let error):
            return "Échec de la requête: \(error.localizedDescription)"
        case .generalNetworkError:
            return "Une erreur réseau s'est produite. Veuillez réessayer."
        case .serverError:
            return "Une erreur serveur s'est produite. Veuillez réessayer plus tard."
        case .erreurInscription:
            return "Erreur d'inscription"
        case .erreurConnexion:
            return "Erreur de connexion"
        case .erreurConnexionFb:
            return "Erreur lors de la connexion via Facebook"
        case .erreurConnexionFirebase:
            return "Erreur lors de la connexion via Firebase"
        case .nomCarteManquante:
            return "Veuillez entrer le nom de la carte que vous souhaitez rechercher"
        case .autreCarteManquante:
            return  "Impossible de trouver la carte demandée. Veuillez vérifier l'orthographe du nom ou essayez une recherche différente"
        case .rechercheCarte:
            return "Une erreur s'est produite lors de la recherche de la carte. Veuillez réessayer"
        case .connexionInternetImage:
            return "Impossible de télécharger l'image. Veuillez vérifier votre connexion et réessayer"
        }
    }
}
