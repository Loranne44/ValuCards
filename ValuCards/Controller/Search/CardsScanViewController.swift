//
//  CardsScannViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation


class SearchCardViewController: UIViewController {
    var names = Set<String>()
    
    @IBOutlet weak var CardNameTextField: UITextField!
    @IBOutlet weak var SearchManuelCardButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchManuelCardButton.layer.cornerRadius = 15
    
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
       search()
    }
    
    func search() {
        CardsModel.shared.searchCards(withName: "pokemon") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(card):
                    print(card)
                    /*
                    let prices = card.itemSummaries.compactMap { Double($0.price.value) } // Convert String prices to Double
                    
                    let minPrice = prices.min()
                    let maxPrice = prices.max()
                    let avgPrice = prices.reduce(0, +) / Double(prices.count)
                    
                    let numberOfSales = card.total  // If 'total' represents the total number of sales
                    
                    print("Min price: \(minPrice ?? 0)")
                    print("Max price: \(maxPrice ?? 0)")
                    print("Avg price: \(avgPrice)")
                    print("Number of sales: \(numberOfSales)")
                    */
                    print(card)
                case let .failure(error):
                    print(error)
                }
            }
            
        }
    }
    
}


/*
 class CardsScanViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
     
     
     
     private var captureSession: AVCaptureSession?
     private var previewLayer: AVCaptureVideoPreviewLayer?
     let modelScan = CardsScanModel()
     let modelManuel = ManualCardSearch()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         setupCameraCapture()
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
     
     private func searchCardByName(_ cardName: String) {
         modelManuel.searchCards(searchKeyword: cardName) { cards, error in
             if let cards = cards {
                 self.handleCards(cards)
             } else if let error = error {
                 self.handleError(error)
             }
         }
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
     
     // AVCaptureVideoDataOutputSampleBufferDelegate method
     func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
         guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
             return
         }
         
         let ciImage = CIImage(cvPixelBuffer: imageBuffer)
         let context = CIContext()
         
         if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
             let capturedImage = UIImage(cgImage: cgImage)
             modelScan.processImage(capturedImage)
         }
     }
 }

 */
