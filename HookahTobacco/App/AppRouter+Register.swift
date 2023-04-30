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
            FireBaseNetworkingServicesAssembly(),
            FirebaseAuthServiceAssembly(),
            RealmDataBaseServiresAssembly(),
            UserDefaultsServiceAssembly(),
            ImageStorageServiceAssembly(),
            AdminDataManagerAssembly(),
            DataManagerAssembly(),
            AdminImageManagerAssembly(),
            ImageManagerAssembly()
        ])
    }

    func registerAppModules() {
        registerModule(AddTobaccoAssembly(), AddTobaccoModule.nameModule) { AddTobaccoModule($0) }
        registerModule(AdminMenuAssembly(), AdminMenuModule.nameModule) { AdminMenuModule($0) }
        registerModule(LoginAssembly(), LoginModule.nameModule) { LoginModule($0) }
        registerModule(AddManufacturerAssembly(), AddManufacturerModule.nameModule) { AddManufacturerModule($0) }
        registerModule(ManufacturerListAssembly(), ManufacturerListModule.nameModule) { ManufacturerListModule($0) }
        registerModule(TobaccoListAssembly(), TobaccoListModule.nameModule) { TobaccoListModule($0) }
        registerModule(DetailInfoManufacturerAssembly(),
                       DetailInfoManufacturerModule.nameModule) { DetailInfoManufacturerModule($0) }
        registerModule(AddTastesAssembly(), AddTastesModule.nameModule) { AddTastesModule($0) }
        registerModule(AddTasteAssembly(), AddTasteModule.nameModule) { AddTasteModule($0) }
        registerModule(DetailTobaccoAssembly(), DetailTobaccoModule.nameModule) { DetailTobaccoModule($0) }
        registerModule(RegistrationAssembly(), RegistrationModule.nameModule) { RegistrationModule($0) }
        registerModule(ProfileAssembly(), ProfileModule.nameModule) { ProfileModule($0) }
    }

    func registerContainerControllers() {
        apply(assemblies: [
            HTNavigationControllerAssembly(),
            HTTabBarControllerAssembly()
        ])
    }

    func assembleContainers() {
        // First container
        let manufacturerListTabBar = TabBarItemContent(title: "Производители",
                                                       image: UIImage(systemName: "note"))
        let manufactureListContainer = (ManufacturerListModule.self, manufacturerListTabBar)

        // second container
        let tobaccoListTabBar = TabBarItemContent(title: "Табаки",
                                                  image: UIImage(systemName: "leaf"))
        let tobaccoListContainer = (TobaccoListModule.self, tobaccoListTabBar)

        // third container
        let tabBarProfile = TabBarItemContent(title: "Профиль",
                                              image: UIImage(systemName: "person"))
        let profileContainer = (ProfileModule.self, tabBarProfile)

        startAppPresent([
            manufactureListContainer,
            tobaccoListContainer,
            profileContainer
        ])
    }
}
