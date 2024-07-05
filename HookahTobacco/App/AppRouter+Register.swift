//
//  AppRouter+Register.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
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
            ImageStorageServiceAssembly()
        ])
    }

    func registerAppModules() {
        registerModule(LoginAssembly(), LoginModule.nameModule) { LoginModule($0) }
        
        registerModule(ManufacturerListAssembly(), ManufacturerListModule.nameModule) { ManufacturerListModule($0) }
        registerModule(TobaccoListAssembly(), TobaccoListModule.nameModule) { TobaccoListModule($0) }
        registerModule(DetailInfoManufacturerAssembly(),
                       DetailInfoManufacturerModule.nameModule) { DetailInfoManufacturerModule($0) }
        registerModule(DetailTobaccoAssembly(), DetailTobaccoModule.nameModule) { DetailTobaccoModule($0) }
        registerModule(RegistrationAssembly(), RegistrationModule.nameModule) { RegistrationModule($0) }
        registerModule(ProfileAssembly(), ProfileModule.nameModule) { ProfileModule($0) }
        registerModule(ProfileEditAssembly(), ProfileEditModule.nameModule) { ProfileEditModule($0) }
        registerModule(DatePickerAssembly(), DatePickerModule.nameModule) { DatePickerModule($0) }
        registerModule(TobaccoFiltersAssembly(), TobaccoFiltersModule.nameModule) { TobaccoFiltersModule($0) }
        registerModule(SelectListBottomSheetAssembly(),
                       SelectListBottomSheetModule.nameModule) { SelectListBottomSheetModule($0) }
        registerModule(CreateAppealsAssembly(), CreateAppealsModule.nameModule) { CreateAppealsModule($0) }
        registerModule(SuccessBottomSheetAssembly(),
                       SuccessBottomSheetModule.nameModule) { SuccessBottomSheetModule($0) }
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
        let authSerivice = resolver.resolve(AuthServiceProtocol.self)!
        let profileContainer = (ProfileModule.self, tabBarProfile)
        let loginContainer = (LoginModule.self, tabBarProfile)

        startAppPresent([
            manufactureListContainer,
            tobaccoListContainer,
            authSerivice.isLoggedIn ? profileContainer : loginContainer
        ])
    }
}
