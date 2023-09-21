//
//  AppDelegate.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var router: AppRouterProtocol?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let router = AppRouter(window!)
        router.registerProviders()
        router.registerServices()
        router.registerAppModules()
        router.registerContainerControllers()

        router.assembleContainers()

        let dataManager = router.resolver.resolve(DataManager.self)!
        dataManager.subscribe(to: SystemNotificationType.self, subscriber: router)
        dataManager.start()

        self.router = router
        window?.makeKeyAndVisible()

        FirebaseApp.configure()

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // TODO: добавить обработку диплинков
        return true
    }
}
