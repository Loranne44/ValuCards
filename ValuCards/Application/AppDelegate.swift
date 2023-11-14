//
//  AppDelegate.swift
//  ValuCards
//
//  Created by Loranne Joncheray on 21/06/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: - UIApplication Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set global appearance for UINavigationBar
        UINavigationBar.appearance().tintColor = UIColor.white
        
        FirebaseApp.configure()
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            window = scene?.windows.first
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser != nil, let searchViewController = storyboard.instantiateViewController(withIdentifier: "searchViewControllerID") as? SearchCardViewController {
            window?.rootViewController = searchViewController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // MARK: - URL Handling for External Authentication
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
