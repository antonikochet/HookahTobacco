//
//  SceneDelegate.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
    
        let navVC = UINavigationController()
        if FireBaseAuthService.shared.isUserLoggerIn {
            let configucator = AdminMenuConfigurator()
            let menuVC = configucator.configure()
            navVC.pushViewController(menuVC, animated: true)
        } else {
            let configurator = LoginConfigurator()
            let loginVC = configurator.configure()
            navVC.pushViewController(loginVC, animated: true)
        }
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

