//
//  CardsScanModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 23/06/2023.
//

/*
 private func searchCardByName(_ cardName: String) {
     // Your implementation to search cards by name
     // For example, you can make an API request or query a database to retrieve cards matching the card name
     // Once you have the cards, you can handle them as needed
     
     // Placeholder implementation to demonstrate searching by card name
     searchCards(searchKeyword: cardName) { cards, error in
         if let cards = cards {
             // Handle the retrieved cards
             print("Search results for card: \(cardName)")
             for card in cards {
                 print("Card: \(card.title)")
                 print("Price: \(card.price.value)")
                 print("Sold Quantity: \(card.sellingStatus.soldQuantity)")
                 print("-----------------------")
             }
         } else if let error = error {
             // Handle the error
             print("Error searching for cards: \(error.localizedDescription)")
         }
     }
 }
 */

/*
 func classifyImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
     guard let ciImage = CIImage(image: image) else {
         completion(nil)
         return
     }
     
     let request = VNCoreMLRequest(model: model) { request, error in
         guard let observations = request.results as? [VNClassificationObservation],
               let topObservation = observations.first else {
             completion(nil)
             return
         }
         
         completion(topObservation.identifier)
     }
     
     let handler = VNImageRequestHandler(ciImage: ciImage)
     
     do {
         try handler.perform([request])
     } catch {
         completion(nil)
     }
 }
 */
import UIKit
import CoreML
import Vision

class CardsScanModel {
    private let cardClassifier = CardClassifier()
    
    func searchCards(searchKeyword: String, completion: @escaping ([Card]?, Error?) -> Void) {
        // Votre implémentation pour rechercher des cartes en fonction d'un mot-clé
        // Par exemple, vous pouvez effectuer une requête API ou interroger une base de données pour récupérer des cartes correspondant au mot-clé de recherche
        // Une fois que vous avez les cartes, vous pouvez analyser la réponse dans un tableau d'objets Card
        
        // Implémentation fictive de l'exemple pour démontrer le gestionnaire de complétion
        let cards: [Card] = []
        completion(cards, nil)
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
                    print("Carte : \(card.title)")
                    print("Prix : \(card.price.value)")
                    print("Quantité vendue : \(card.sellingStatus.soldQuantity)")
                    print("-----------------------")
                }
            } else if let error = error {
                // Gérez l'erreur
                print("Erreur lors de la recherche des cartes : \(error.localizedDescription)")
            }
        }
    }
    
    func processImage(_ image: UIImage) {
        // Votre implémentation pour le traitement de l'image
        // Par exemple, vous pouvez utiliser Vision pour classer l'image en utilisant le modèle CardClassifier
        // Une fois que vous avez les résultats de classification, vous pouvez effectuer des opérations supplémentaires en fonction des noms de carte identifiés
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        let request = VNCoreMLRequest(model: cardClassifier.model) { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else {
                return
            }
            
            let cardNames = observations
                .filter { $0.confidence > 0.5 }
                .map { $0.identifier }
            
            for cardName in cardNames {
                self.searchCardByName(cardName)
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Erreur lors du traitement de l'image : \(error.localizedDescription)")
        }
    }
}
