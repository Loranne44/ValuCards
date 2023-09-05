//
//  UIViewController+Alerts.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(for error: ErrorCase, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Erreur", message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccessPopup(for success: SuccessCase, segueIdentifier: String? = nil) {
        let alert = UIAlertController(title: "Succès", message: success.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            if let identifier = segueIdentifier {
                self?.performSegue(withIdentifier: identifier, sender: nil)
            }
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
