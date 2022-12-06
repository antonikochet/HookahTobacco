//
//  SceneDelegate.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let router = AppRouter(window!)
        router.registerServices()
        router.registerAppModules()
        router.registerContainerControllers()
        router.assembleContainers()

        let dataManager = router.resolver.resolve(DataManager.self)!
        dataManager.subscribe(to: SystemNotificationType.self, subscriber: router)
        dataManager.start()

        window?.makeKeyAndVisible()
    }
}
