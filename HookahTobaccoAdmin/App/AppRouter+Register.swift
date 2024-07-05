//
//  AppRouter+Register.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 05.07.2024.
//

import UIKit

extension AppRouter {
    func registerProviders() {
        apply(assemblies: [
            MoyaProviderAssembly(),
        ])
    }

    func registerServices() {
        apply(assemblies: [
            UserDefaultsServiceAssembly(),
            ApiNetworkingServicesAssembly(),
            ApiAuthServiceAssembly(),
        ])
    }

    func registerAppModules() {
        registerModule(ProfileAssembly(), ProfileModule.nameModule) { ProfileModule($0) }
        registerModule(LoginAssembly(), LoginModule.nameModule) { LoginModule($0) }
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
