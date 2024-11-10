//
//  AppRouter+Register.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 05.07.2024.
//

import UIKit
import HookahTobaccoCore

extension AppRouter {
    func registerProviders() {
        apply(assemblies: [
            MoyaProviderAssembly(),
        ])
    }

    func registerServices() {
        apply(assemblies: [
            UserSettingsServiceAssembly(),
            AnalyticsServicesAssembly(),
            RepoAssembly(),
            AdminRepoAssembly(),
            AuthServiceAssembly(),
            ImageStorageServiceAssembly(),
            DataManagerAssembly()
        ])
    }

    func registerAppModules() {
        registerModule(ProfileAssembly(), ProfileModule.nameModule) { ProfileModule($0) }
        registerModule(LoginAssembly(), LoginModule.nameModule) { LoginModule($0) }
        registerModule(AdminMenuAssembly(), AdminMenuModule.nameModule) { AdminMenuModule($0) }
        
        registerModule(AddManufacturerAssembly(), AddManufacturerModule.nameModule) { AddManufacturerModule($0) }
        registerModule(AddCountryAssembly(), AddCountryModule.nameModule) { AddCountryModule($0) }
        registerModule(AddTobaccoLineAssembly(), AddTobaccoLineModule.nameModule) { AddTobaccoLineModule($0) }
        registerModule(AddTobaccoAssembly(), AddTobaccoModule.nameModule) { AddTobaccoModule($0) }
        registerModule(AddTastesAssembly(), AddTastesModule.nameModule) { AddTastesModule($0) }
        registerModule(AddTasteAssembly(), AddTasteModule.nameModule) { AddTasteModule($0) }
        registerModule(AppealsListAssembly(), AppealsListModule.nameModule) { AppealsListModule($0) }
        registerModule(DetailAppealAssembly(), DetailAppealModule.nameModule) { DetailAppealModule($0) }
    }

    func registerContainerControllers() {
        apply(assemblies: [
            HTNavigationControllerAssembly(),
            HTTabBarControllerAssembly()
        ])
    }

    func assembleContainers() {
        let tabBarProfile = TabBarItemContent(title: "Admin",
                                              image: UIImage(systemName: "person"))
        let authSerivice = resolver.resolve(AuthServiceProtocol.self)!
        let profileContainer = (ProfileModule.self, tabBarProfile)
        let loginContainer = (LoginModule.self, tabBarProfile)

        startAppPresent([
            authSerivice.isLoggedIn ? profileContainer : loginContainer
        ])
    }
}
