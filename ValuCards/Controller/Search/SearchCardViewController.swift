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
    
    /// Configures the navigation bar, setting up the back button
    private func setupNavigationBar() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    /// Customizes the appearance of the search button
    private func setupSearchButton() {
        searchManuelCardButton.layer.cornerRadius = 15
    }
    
    /// Sets up the country picker view, including its data source and delegate
    private func setupCountryPicker() {
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
    }
    
    /// Sets the country picker to the user's previously saved country choice
    private func setSavedCountry() {
            if let savedCountry = CountryManager.shared.getSavedCountryChoice(),
               let index = EbayCountry.allCases.firstIndex(of: savedCountry) {
                countryPickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    
    // MARK: - IBActions
    
    /// Initiates a manual card search
    @IBAction func SearchManuelCardButton(_ sender: UIButton) {
        let trace = Performance.startTrace(name: "manual_card_search")
            search() {
                trace?.stop()
            }
    }
    
    // MARK: - Search Logic
    
    /// Performs the search for cards based on user input
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

    /// Handles errors encountered during card search
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
    
    /// Prepares data for segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideViewControllerSegue",
           let slideViewController = segue.destination as? SlideViewController {
            slideViewController.imagesAndTitles = imagesAndTitlesToSend
            slideViewController.selectedCountry = EbayCountry.allCases[countryPickerView.selectedRow(inComponent: 0)]
        }
    }
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
