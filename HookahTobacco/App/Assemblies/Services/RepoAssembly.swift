//
//  RepoAssembly.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Swinject
import Moya
import HookahTobaccoNetwork
import HookahTobaccoCore

final class RepoAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HookahTobaccoNetwork.NetworkHandlerErrors.self) { _ in
            HookahTobaccoNetwork.ApiHandlerErrors()
        }
        container.register(NetworkManagerProtocol.self) { resolver in
            MoyaNetworkManager(networkProvider: resolver.resolve(MoyaProvider<MultiTarget>.self)!)
        }
        
        container.register(AuthorizationRepoProtocol.self) { resolver in
            AuthorizationRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                              authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                              handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!,
                              sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(AppealsRepoProtocol.self) { resolver in
            AppealsRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                        authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                        handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!,
                        sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
    }
}
