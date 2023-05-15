//
//  SceneDelegate.swift
//  Foody
//
//  Created by Khater on 5/3/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let isSeeOnboardingPage = UserDefaults.standard.bool(forKey: "isSeeOnboardingPage")
        
        let rootVC = isSeeOnboardingPage ? HomeViewController() : OnboardingViewController()
        let nav = UINavigationController(rootViewController: rootVC)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}

