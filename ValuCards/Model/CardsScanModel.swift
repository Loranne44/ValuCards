//
//  CardsScanModel.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 23/06/2023.
//

import UIKit
import CoreML
import Vision

class CardsScanModel {
    private let cardClassifier = CardClassifier()
    
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
            
            /*
             let cardNames = observations
             .filter { $0.confidence > 0.5 }
             .map { $0.identifier }
             
             for cardName in cardNames {
             self.searchCardByName(cardName)
             }*/
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            print("Erreur lors du traitement de l'image : \(error.localizedDescription)")
        }
    }
}
