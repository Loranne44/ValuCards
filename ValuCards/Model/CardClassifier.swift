//
//  CardClassifier.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 27/06/2023.
//

import Foundation
import UIKit
import CoreML
import Vision

//la classe CardClassifier est responsable de la classification des images de cartes à jouer en utilisant un modèle Core ML pré-entraîné, et elle fournit une interface pour utiliser cette fonctionnalité dans le modèle CardsScanModel.

class CardClassifier {
    let model: VNCoreMLModel
    
    init() {
        guard let model = try? VNCoreMLModel(for: CardClassifierModel.Model()) else {
            fatalError("Échec du chargement du modèle CoreML")
        }
        self.model = model
    }
    
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
}
