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
    
    func setupBackButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.left")
        navigationItem.backBarButtonItem = backBarButton
    }
    
    func setupBackgroundImageView(for imageView: UIImageView, with scrollView: UIScrollView) {
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.view.backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
    }
}
