//
//  SearchCardViewController.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import AVFoundation
import FirebaseAuth
import Firebase
import FirebasePerformance

class SearchCardViewController: UIViewController {
    
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
            if let savedCountry = CountryManager.shared.getSavedCountryChoice(),
               let index = EbayCountry.allCases.firstIndex(of: savedCountry) {
                countryPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    
    // MARK: - IBActions
    @IBAction func didTapLogoutBotton(_ sender: UIButton) {
        do {
                    try Auth.auth().signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let authVC = storyboard.instantiateViewController(withIdentifier: "authViewControllerID") as? AuthViewController {
                        let navController = UINavigationController(rootViewController: authVC)
                        self.view.window?.rootViewController = navController
                        self.view.window?.makeKeyAndVisible()
                    }
                } catch {
                    showAlert(for: .signOutError)
                }
        /*AuthenticationManager.shared.logout { [weak self] result in
                    switch result {
                    case .success:
                        // Navigate to auth VC or perform other UI updates
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let authVC = storyboard.instantiateViewController(withIdentifier: "authViewControllerID") as? AuthViewController {
                            let navController = UINavigationController(rootViewController: authVC)
                            self?.view.window?.rootViewController = navController
                            self?.view.window?.makeKeyAndVisible()
                        }
                    case .failure:
                        self?.showAlert(for: .signOutError)
                    }*/
                
    }
    
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        let trace = Performance.startTrace(name: "manual_card_search")
            search() {
                trace?.stop()
            }
    }
    
    // MARK: - Search Logic
    // MARK: - Search Logic
    func search(completion: @escaping () -> Void) {
        guard let name = cardNameTextField.text, !name.isEmpty else {
            showAlert(for: .cardNameMissing)
            completion() 
            return
        }
        
        let selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        let trace = Performance.startTrace(name: "search_cards")

        CardsModel.shared.searchCards(withName: name, inCountry: selectedCountry) { [weak self] result in
            trace?.stop()
            DispatchQueue.main.async {
                switch result {
                    
                case let .success(card):
                     let imagesAndTitles = card.itemSummaries
                        .compactMap { summary -> (imageName: String, title: String)? in
                            guard let imageUrl = summary.thumbnailImages?.first?.imageUrl else { return nil }
                            return (imageName: imageUrl, title: summary.title)
                        }
                    
                    self?.imagesAndTitlesToSend = imagesAndTitles
                    self?.performSegue(withIdentifier: "SlideViewControllerSegue", sender: self)
                    
                case let .failure(error):
                    self?.handleSearchError(error)
                }
                completion()
            }
        }
    }

    private func handleSearchError(_ error: ErrorCase) {
        switch error {
        case .noCardsFound:
            showAlert(for: .noCardsFound)
        case .invalidURL:
            showAlert(for: .invalidURL)
        case .serverError:
            showAlert(for: .serverError)
        case .generalNetworkError:
            showAlert(for: .generalNetworkError)
        case .jsonDecodingError:
            showAlert(for: .jsonDecodingError)
        case .cardNameMissing:
            showAlert(for: .cardNameMissing)
        case .requestFailed:
            showAlert(for: .requestFailed)
        case .resourceNotFound:
            showAlert(for: .resourceNotFound)
        case .otherCardMissing:
            showAlert(for: .otherCardMissing)
        case .cardSearchError:
            showAlert(for: .cardSearchError)
        default:
            showAlert(for: .generalNetworkError)
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
    
    /*
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
    }*/
   
}

extension SearchCardViewController : UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EbayCountry.allCases.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension SearchCardViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return EbayCountry.allCases[row].displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = EbayCountry.allCases[row]
        CountryManager.shared.saveCountryChoice(selectedCountry)
    }
}
