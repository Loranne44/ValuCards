//
//  CardsScannViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import Foundation
import UIKit
import AVFoundation
import Vision


class CardsScanViewController: UIViewController {
    
    private let model = CardsModel()
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation de la capture de la caméra
        setupCameraCapture()
        
        // Appel de la fonction pour scanner une carte
        scanCard()
        
        // Exemple d'utilisation en saisissant manuellement le nom de la carte
        searchCardByName("Pikachu")
    }
    
    private func setupCameraCapture() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Impossible d'accéder à la caméra")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.frame = view.bounds
            previewLayer?.videoGravity = .resizeAspectFill
            
            if let previewLayer = previewLayer {
                view.layer.addSublayer(previewLayer)
            }
            
            captureSession?.startRunning()
        } catch {
            print("Erreur lors de la configuration de la capture de la caméra : \(error.localizedDescription)")
        }
    }
    
    private func scanCard() {
        guard let captureSession = captureSession else {
            print("Capture de la caméra non initialisée")
            return
        }
        
        // Capture d'une image depuis la caméra
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .utility))
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Ajouter un bouton pour la saisie manuelle du nom de la carte
        let manualButton = UIButton(type: .system)
        manualButton.setTitle("Saisir manuellement", for: .normal)
        manualButton.addTarget(self, action: #selector(manualButtonTapped), for: .touchUpInside)
        view.addSubview(manualButton)
        
        // Définir les contraintes pour le bouton
        manualButton.translatesAutoresizingMaskIntoConstraints = false
        manualButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        manualButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    private func searchCardByName(_ cardName: String) {
        model.searchCards(searchKeyword: cardName) { cards, error in
            if let cards = cards {
                self.handleCards(cards)
            } else if let error = error {
                self.handleError(error)
            }
        }
    }
    
    @objc private func manualButtonTapped() {
        let alertController = UIAlertController(title: "Saisir le nom de la carte", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Nom de la carte"
        }
        
        let searchAction = UIAlertAction(title: "Rechercher", style: .default) { _ in
            if let cardName = alertController.textFields?.first?.text {
                self.searchCardByName(cardName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func handleCards(_ cards: [Card]) {
        for card in cards {
            print("Carte : \(card.title)")
            print("Prix moyen : \(card.price.value)")
            print("Nombre de ventes sur un mois : \(card.sellingStatus.soldQuantity)")
            print("------------------------------")
        }
    }
    
    private func handleError(_ error: Error) {
        print("Erreur : \(error.localizedDescription)")
    }
    
    private func searchCardByImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
               print("Impossible de convertir l'image en CGImage")
               return
           }
           
           let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
           
           let textRecognitionRequest = VNRecognizeTextRequest { request, error in
               if let error = error {
                   print("Erreur lors de la reconnaissance de texte : \(error.localizedDescription)")
                   return
               }
               
               guard let observations = request.results as? [VNRecognizedTextObservation] else {
                   print("Aucune observation de texte trouvée")
                   return
               }
               
               var cardName = ""
               
               for observation in observations {
                   guard let topCandidate = observation.topCandidates(1).first else { continue }
                   cardName += topCandidate.string + " "
               }
               
               if !cardName.isEmpty {
                   cardName = cardName.trimmingCharacters(in: .whitespaces)
                   self.searchCardByName(cardName)
               } else {
                   print("Aucun texte reconnu dans l'image")
               }
           }
           
           textRecognitionRequest.recognitionLevel = .accurate
           
           do {
               try requestHandler.perform([textRecognitionRequest])
           } catch {
               print("Erreur lors de la reconnaissance de texte : \(error.localizedDescription)")
           }
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        // Création d'une requête de détection d'objet
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            var cardNames: [String] = []
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else {
                    continue
                }
                
                let cardName = topCandidate.string
                cardNames.append(cardName)
            }
            
            // Recherche des informations sur les cartes détectées
            for cardName in cardNames {
                self?.searchCardByName(cardName)
            }
        }
        
        // Configuration de la requête de détection d'objet
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            // Exécution de la requête de détection d'objet
            try handler.perform([request])
        } catch {
            print("Erreur lors de la détection d'objet : \(error)")
        }
    }
}

extension CardsScanViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let capturedImage = UIImage(cgImage: cgImage)
            
            // Process the captured image
            processImage(capturedImage)
            
            // Stop capturing after processing one frame
            captureSession?.stopRunning()
        }
    }
}
