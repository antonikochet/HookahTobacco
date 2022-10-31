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
        
        let router = AppRouter(window!)
        router.registerServices()
        router.registerAppModules()
        router.registerContainerControllers()
        router.assembleContainers()
        
        window?.makeKeyAndVisible()
    }
}

fileprivate extension AppRouter {
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
        registerModule(TobaccoListAssembly(), TobaccoListModule.nameModule) { TobaccoListModule($0) }
    }
    
    func registerContainerControllers() {
        apply(assemblies: [
            HTNavigationControllerAssembly(),
            HTTabBarControllerAssembly()
        ])
    }
    
    func assembleContainers() {
        //First container
        let manufacturerListTabBar = TabBarItemContent(title: "Производители",
                                                       image: UIImage(systemName: "note"))
        let manufactureListContainer = (ManufacturerListModule.self, manufacturerListTabBar)
        
        //second container
        let tobaccoListTabBar = TabBarItemContent(title: "Табаки",
                                                  image: UIImage(systemName: "leaf"))
        let tobaccoListContainer = (TobaccoListModule.self, tobaccoListTabBar)
        
        //third container
        let TabBarProfile = TabBarItemContent(title: "Профиль",
                                              image: UIImage(systemName: "person"))
        let profileContainer: (ModuleProtocol.Type, TabBarItemProtocol)
        if FireBaseAuthService.shared.isUserLoggerIn {
            profileContainer = (AdminMenuModule.self, TabBarProfile)
        } else {
            profileContainer = (LoginModule.self, TabBarProfile)
        }
        
        
        startAppPresent([
            manufactureListContainer,
            tobaccoListContainer,
            profileContainer,
            
        ])
    }
}
