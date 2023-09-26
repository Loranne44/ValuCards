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
    
    // MARK: - Properties
    var imagesAndTitlesToSend: [(imageName: String, title: String)] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Initial Setup
    private func initialSetup() {
        setupNavigationBar()
        setupSearchButton()
        setupCountryPicker()
        setSavedCountry()
    }
    
    private func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    private func setupSearchButton() {
        searchManuelCardButton.layer.cornerRadius = 15
    }
    
    private func setupCountryPicker() {
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
    }
    
    private func setSavedCountry() {
        if let savedCountry = getSavedCountryChoice(),
           let index = EbayCountry.allCases.firstIndex(of: savedCountry) {
            countryPickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func didTapLogoutBotton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let authVC = storyboard.instantiateViewController(withIdentifier: "authViewControllerID") as? AuthViewController {
                let navController = UINavigationController(rootViewController: authVC)
                self.view.window?.rootViewController = navController
                self.view.window?.makeKeyAndVisible()
            }
            
        } catch let signOutError {
            print("Erreur lors de la déconnexion: \(signOutError)")
        }
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        search()
    }
    
    // MARK: - Search Logic
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideViewControllerSegue",
           let slideViewController = segue.destination as? SlideViewController {
            slideViewController.imagesAndTitles = imagesAndTitlesToSend
            slideViewController.selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    // MARK: - User Defaults
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = EbayCountry.allCases[row]
        saveCountryChoice(country: selectedCountry)
    }
}
