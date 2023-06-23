//
//  CardsScanner.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 23/06/2023.
//

import Foundation
import UIKit
import AVFoundation
import CoreML
import Vision

protocol CardsScanManagerDelegate: AnyObject {
    func cardsScanManager(_ manager: CardsScanManager, didCaptureImage image: UIImage)
    func cardsScanManager(_ manager: CardsScanManager, didDetectCardNames cardNames: [String])
}

class CardsScanManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession: AVCaptureSession?
    
    weak var delegate: CardsScanManagerDelegate?
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: CardClassifier().model)
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                self?.processClassificationResults(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Erreur lors du chargement du modèle CoreML : \(error)")
        }
    }()
    
    func startCapture() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Impossible d'accéder à la caméra")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .utility))
            
            if let captureSession = captureSession, captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
                
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = .resizeAspectFill
                
                // Ajoutez la previewLayer à votre interface utilisateur
                
                captureSession.startRunning()
            }
        } catch {
            print("Erreur lors de la configuration de la capture de la caméra : \(error.localizedDescription)")
        }
    }
    
    func stopCapture() {
        captureSession?.stopRunning()
    }
    
    private func processClassificationResults(for request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            print("Erreur lors du traitement des résultats de classification")
            return
        }
        
        let cardNames = results.map { $0.identifier }
        delegate?.cardsScanManager(self, didDetectCardNames: cardNames)
    }
    
    private func classifyImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Erreur lors de la classification de l'image : \(error)")
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let capturedImage = UIImage(cgImage: cgImage)
            delegate?.cardsScanManager(self, didCaptureImage: capturedImage)
            classifyImage(capturedImage)
        }
    }
}

