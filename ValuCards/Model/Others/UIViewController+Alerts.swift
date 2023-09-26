//
//  UIViewController+Alerts.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 04/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Alert Presentation
    func showAlert(for error: ErrorCase, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
