//
//  UIViewController+Alerts.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    /// PopUp Alert
    func showAlert(for error: ErrorCase, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    func showSuccessPopUp(for success: SuccessCase, segueIdentifier: String? = nil) {
        let alert = UIAlertController(title: nil, message: success.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            if let identifier = segueIdentifier {
                self?.performSegue(withIdentifier: identifier, sender: nil)
            }
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }*/
}
