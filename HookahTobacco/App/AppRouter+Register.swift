//
//  AppRouter+Register.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//

import UIKit

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
