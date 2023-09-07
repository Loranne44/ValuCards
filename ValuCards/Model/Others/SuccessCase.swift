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
    case inscriptionReussi
    case connexionReussi
    case connexionFb
    case connexionFirebase
    case customMessage(String)
   

    var message: String {
        switch self {
        case .cardAddedSuccessfully:
            return "Carte ajoutée avec succès."
        case .cardUpdatedSuccessfully:
            return "Carte mise à jour avec succès."
        case .inscriptionReussi:
            return "Inscription réussie !"
        case .connexionReussi:
            return "Connexion réussie !"
        case .connexionFb:
            return "Connexion via Firebase réussie !"
        case .connexionFirebase:
            return "Connexion réussie !"
        case .customMessage(let customMsg): 
                    return customMsg
      
        }
    }
}
