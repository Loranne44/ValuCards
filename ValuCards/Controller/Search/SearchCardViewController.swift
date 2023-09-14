//
//  CardsScannViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation

class SearchCardViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: - Outlets
    @IBOutlet weak var CardNameTextField: UITextField!
    @IBOutlet weak var SearchManuelCardButton: UIButton!
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    var imagesAndTitlesAndPricesToSend: [(imageName: String, title: String, price: Price)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchManuelCardButton.layer.cornerRadius = 15
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        // Set the saved country from previous user choice
        if let savedCountry = getSavedCountryChoice(),
           let index = EbayCountry.allCases.firstIndex(of: savedCountry) {
            countryPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        search()
    }
    
    func search() {
        guard let name = CardNameTextField.text, !name.isEmpty else {
            self.showAlert(for: .cardNameMissing)
            return
        }
        
        let selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        
        // Initiate card search
        CardsModel.shared.searchCards(withName: name, inCountry: selectedCountry) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(card):
                    let imagesAndTitlesAndPrices = card.itemSummaries.flatMap { summary in
                        summary.thumbnailImages.map { image in
                            (imageName: image.imageUrl, title: summary.title, price: summary.price)
                        }
                    }
                    
                    self.imagesAndTitlesAndPricesToSend = imagesAndTitlesAndPrices
                    self.performSegue(withIdentifier: "SlideViewControllerSegue", sender: self)
                case let .failure(error):
                    switch error {
                    case .noCardsFound:
                        self.showAlert(for: .otherCardMissing)
                    default:
                        self.showAlert(for: .otherCardMissing)
                    }
                }
            }
        }
    }
    
    
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EbayCountry.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EbayCountry.allCases[row].displayName
    }
    
    // Save user's country choice upon selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = EbayCountry.allCases[row]
        saveCountryChoice(country: selectedCountry)
    }
    
    // Pass data to the next view before the segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideViewControllerSegue",
           let slideViewController = segue.destination as? SlideViewController {
            slideViewController.imagesAndTitlesAndPrices = imagesAndTitlesAndPricesToSend
            slideViewController.selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    // Save the country choice for the user in UserDefaults
    func saveCountryChoice(country: EbayCountry) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(country.rawValue, forKey: "selectedEbayCountry")
    }
    
    // Retrieve saved country choice from UserDefaults
    func getSavedCountryChoice() -> EbayCountry? {
        let userDefaults = UserDefaults.standard
        if let savedCountryRawValue = userDefaults.string(forKey: "selectedEbayCountry"),
           let savedCountry = EbayCountry(rawValue: savedCountryRawValue) {
            return savedCountry
        }
        return nil
    }
}

// UsersPreference -> stockage basique pour Mettre les US __OK

// Mettre les US par défaut et enregistrer le choix précédant pour le réafficher a la prochaine connexion __OK
// Le back en blanc avec une classe
// inscription/Connexion 
// Tests
// Changer les logos
// Favoris ? Garder dans l'application et que ca ne puisse pas etre transmis
// Dark mode ??
