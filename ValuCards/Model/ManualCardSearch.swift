//
//  ManualCardSearch.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation

class ManualCardSearch {
    
    func searchCards(searchKeyword: String, completion: @escaping ([EbayBrowseResponse]?, Error?) -> Void) {
        // Votre implémentation pour rechercher des cartes en fonction d'un mot-clé
        // Par exemple, vous pouvez effectuer une requête API ou interroger une base de données pour récupérer des cartes correspondant au mot-clé de recherche
        // Une fois que vous avez les cartes, vous pouvez analyser la réponse dans un tableau d'objets Card
        
        // Implémentation fictive de l'exemple pour démontrer le gestionnaire de complétion
        let cards: [EbayBrowseResponse] = []
        completion(cards, nil)
        print (cards)
    }
    
    private func searchCardByName(_ cardName: String) {
        // Votre implémentation pour rechercher des cartes par nom
        // Par exemple, vous pouvez effectuer une requête API ou interroger une base de données pour récupérer des cartes correspondant au nom de la carte
        // Une fois que vous avez les cartes, vous pouvez les traiter comme nécessaire
        
        // Implémentation fictive de l'exemple pour la recherche par nom de carte
        searchCards(searchKeyword: cardName) { cards, error in
            if let cards = cards {
                // Gérez les cartes récupérées
                print("Résultats de recherche pour la carte : \(cardName)")
                for card in cards {
                  //  print("Carte : \(card.title)")
                  //  print("Prix : \(card.price.value)")
                 //   print("Quantité vendue : \(card.sellingStatus.soldQuantity)")
                    print("-----------------------")
                }
            } else if let error = error {
                // Gérez l'erreur
                print("Erreur lors de la recherche des cartes : \(error.localizedDescription)")
            }
        }
    }
}
