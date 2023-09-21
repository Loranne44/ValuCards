//
//  SearchCardViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation
import FirebaseAuth

class SearchCardViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var searchManuelCardButton: UIButton!
    @IBOutlet weak var countryPickerView: UIPickerView!
    
    var imagesAndTitlesToSend: [(imageName: String, title: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchManuelCardButton.layer.cornerRadius = 15
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        // Navigation settings
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // Set the saved country from previous user choice
        if let savedCountry = getSavedCountryChoice(),
           let index = EbayCountry.allCases.firstIndex(of: savedCountry) {
            countryPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError {
            print("Erreur lors de la déconnexion: \(signOutError)")
        }
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        search()
    }
    
    func search() {
        guard let name = cardNameTextField.text, !name.isEmpty else {
            self.showAlert(for: .cardNameMissing)
            return
        }
        
        let selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        
        CardsModel.shared.searchCards(withName: name, inCountry: selectedCountry) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                
                switch result {
                case let .success(card):
                    let imagesAndTitles = card.itemSummaries
                        .compactMap { summary -> (imageName: String, title: String)? in
                            guard let imageUrl = summary.thumbnailImages?.first?.imageUrl else { return nil }
                            return (imageName: imageUrl, title: summary.title)
                        }
                    
                    self.imagesAndTitlesToSend = imagesAndTitles
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
            slideViewController.imagesAndTitles = imagesAndTitlesToSend
            slideViewController.selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    // Save and Retrieve user's country choice
    func saveCountryChoice(country: EbayCountry) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(country.rawValue, forKey: "selectedEbayCountry")
    }
    
    func getSavedCountryChoice() -> EbayCountry? {
        let userDefaults = UserDefaults.standard
        if let savedCountryRawValue = userDefaults.string(forKey: "selectedEbayCountry"),
           let savedCountry = EbayCountry(rawValue: savedCountryRawValue) {
            return savedCountry
        }
        return nil
    }
}



// Mettre les US par défaut et enregistrer le choix précédant pour le réafficher a la prochaine connexion __OK
// Le back en blanc avec une classe
// inscription/Connexion Google/facebook / Apple
// Tests
// Changer les logos
// Favoris ? Garder dans l'application et que ca ne puisse pas etre transmis ??
// Dark mode ??

// Mémoriser l'utilisateur connecté

// Décaler l'appel réseau qui affiche le graphique dans le slide et non le search ?
