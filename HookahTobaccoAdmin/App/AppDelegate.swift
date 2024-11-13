//
//  AppDelegate.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 05.07.2024.
//

import UIKit
import HookahTobaccoResources

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: AppRouterProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        LocalizationManager.provider = RSwiftLocalizationProvider()
        ResourceManager.provider = RSwiftResourcesProvider()
        
        let router = AppRouter(window)
        
        router.registerProviders()
        router.registerServices()
        router.registerAppModules()
        router.registerContainerControllers()

        router.assembleContainers()

        self.window = window
        self.router = router
        window.makeKeyAndVisible()
        
        return true
    }

}

