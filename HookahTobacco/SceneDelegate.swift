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
        
        let assembler = AppRouter()
        assembler.navigationController = navVC
        assembler.registerServices()
        assembler.registerAppModules()
        
        if FireBaseAuthService.shared.isUserLoggerIn {
            assembler.presentView(module: AdminMenuModule.self, animated: true)
        } else {
            assembler.presentView(module: LoginModule.self, animated: true)
        }
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

extension AppRouter {
    func registerServices() {
        apply(assemblies: [
            ServiceAssembly()
        ])
        
    }
    
    func registerAppModules() {
        registerModule(AddTobaccoAssembly(), AddTobaccoModule.nameModule) { AddTobaccoModule($0) }
        registerModule(AdminMenuAssembly(), AdminMenuModule.nameModule) { AdminMenuModule($0) }
        registerModule(LoginAssembly(), LoginModule.nameModule) { LoginModule($0) }
        registerModule(AddManufacturerAssembly(), AddManufacturerModule.nameModule) { AddManufacturerModule($0) }
        registerModule(ManufacturerListAssembly(), ManufacturerListModule.nameModule) { ManufacturerListModule($0) }
    }
}
