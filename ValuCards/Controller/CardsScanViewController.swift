//
//  CardsScannViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation
import Vision
import CoreML

class CardsScanViewController: UIViewController {

    private let model = CardsModel()
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var cardsScanManager: CardsScanManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialisation de la capture de la caméra
        setupCameraCapture()
        
        // Initialisation du manager de scan
        cardsScanManager = CardsScanManager()
        cardsScanManager?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startCameraCapture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopCameraCapture()
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
        } catch {
            print("Erreur lors de la configuration de la capture de la caméra : \(error.localizedDescription)")
        }
    }
    
    private func startCameraCapture() {
        captureSession?.startRunning()
    }
    
    private func stopCameraCapture() {
        captureSession?.stopRunning()
    }
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        // Utilisation du manager de scan pour la reconnaissance d'image
        cardsScanManager?.classifyImage(cgImage)
    }
}

extension CardsScanViewController: CardsScanManagerDelegate {
    func cardsScanManager(_ manager: CardsScanManager, didDetectCardNames cardNames: [String]) {
        // Traitement des noms de cartes détectées
        for cardName in cardNames {
            searchCardByName(cardName)
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
            
            // Traiter l'image capturée
            processImage(capturedImage)
        }
    }
}
