//
//  RepoAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Swinject
import HookahTobaccoNetwork
import HookahTobaccoCore

final class RepoAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkHandlerErrors.self) { _ in
            HookahTobaccoNetwork.ApiHandlerErrors()
        }
        container.register(NetworkManagerProtocol.self) { resolver in
            MoyaNetworkManager(networkProvider: resolver.resolve(MultiMoyaProvider.self)!)
        }
        container.register(HookahTobaccoNetwork.ImageManagerProtocol.self) { _ in
            HookahTobaccoNetwork.ImageManager()
        }
        container.register(ImageManagerProtocol.self) { resolver in
            ImageManager(imageManager: resolver.resolve(HookahTobaccoNetwork.ImageManagerProtocol.self)!,
                         handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        
        container.register(AuthorizationRepoProtocol.self) { resolver in
            AuthorizationRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(RegistrationRepoProtocol.self) { resolver in
            RegistrationRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(AppealsRepoProtocol.self) { resolver in
            AppealsRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(UserRepoProtocol.self) { resolver in
            UserRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(TasteTypeRepoProtocol.self) { resolver in
            TasteTypeRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(TasteRepoProtocol.self) { resolver in
            TasteRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(CountryRepoProtocol.self) { resolver in
            CountryRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(ManufacturerRepoProtocol.self) { resolver in
            ManufacturerRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(FavoriteTobaccoRepoProtocol.self) { resolver in
            FavoriteTobaccoRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(WantBuyTobaccoRepoProtocol.self) { resolver in
            WantBuyTobaccoRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(TobaccoRepoProtocol.self) { resolver in
            TobaccoRepo(
                networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!,
                sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
    }
}
