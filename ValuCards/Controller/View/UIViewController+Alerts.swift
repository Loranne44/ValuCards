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
    
    /// Presents an alert with a given error message and an optional completion handler
    func showAlert(for error: ErrorCase, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation UI Setup
    
    /// Sets up a custom back button for the navigation bar
    func setupBackButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationItem.backBarButtonItem = backBarButton
    }
    
    // MARK: - UI Configuration
    /// Configures background image view and makes the scroll view's background clear
    func setupBackgroundImageView(for imageView: UIImageView, with scrollView: UIScrollView) {
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.view.backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
    }
}
