//
//  AppDelegate.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FacebookCore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    // MARK: - UIApplication Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set global appearance for UINavigationBar
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initial navigation setup based on authentication state
        setupInitialViewController()
        
        return true
    }
    
    // MARK: - Initial View Controller Setup
    private func setupInitialViewController() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if Auth.auth().currentUser == nil {
                if let authVC = storyboard.instantiateViewController(withIdentifier: "authViewControllerID") as? AuthViewController {
                    window?.rootViewController = authVC
                    window?.makeKeyAndVisible()
                }
            } else {
                if let searchNavigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
                    window?.rootViewController = searchNavigationController
                    window?.makeKeyAndVisible()
                }
            }
    }

    // MARK: - URL Handling for External Authentication
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let handledByFacebook = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let handledByGoogle = GIDSignIn.sharedInstance.handle(url)
        
        return handledByFacebook || handledByGoogle
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
}


// Premier pint d'entrée :
// Identification , si connecté

