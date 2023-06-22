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


class CardsScannViewController: UIViewController {
    
    private let model = PokemonCardsModel()
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation de la capture de la caméra
        setupCameraCapture()
        
        // Appel de la fonction pour scanner une carte
        scanPokemonCard()
        
        // Exemple d'utilisation en saisissant manuellement le nom de la carte
        searchPokemonCardByName("Pikachu")
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
    
    private func scanPokemonCard() {
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
    
    private func searchPokemonCardByName(_ cardName: String) {
        model.searchPokemonCards(searchKeyword: cardName) { cards, error in
            if let cards = cards {
                self.handlePokemonCards(cards)
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
                self.searchPokemonCardByName(cardName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func handlePokemonCards(_ cards: [Card]) {
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
    
    private func searchPokemonCardByImage(_ image: UIImage) {
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
                   self.searchPokemonCardByName(cardName)
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
        // Implémentez ici la logique de traitement de l'image capturée
        
        // Par exemple, vous pouvez effectuer une analyse d'image, une reconnaissance d'objet, etc.
        // Pour cet exemple, nous affichons simplement l'image capturée dans une vue
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 100)
        view.addSubview(imageView)
        
        // Appel de la recherche des informations sur la carte à partir de l'image
        searchPokemonCardByImage(image)
    }
}

extension CardsScannViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
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
