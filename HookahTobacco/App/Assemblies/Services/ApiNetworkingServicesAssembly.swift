//
//  ApiNetworkingServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Swinject
import Moya
import HookahTobaccoCore
import HookahTobaccoNetwork

class ApiNetworkingServicesAssembly: Assembly {
    func assemble(container: Container) {

        container.register(NetworkHandlerErrors.self) { _ in
            ApiHandlerErrors()
        }
        container.register(HookahTobaccoNetwork.NetworkHandlerErrors.self) { _ in
            HookahTobaccoNetwork.ApiHandlerErrors()
        }
        container.register(NetworkManagerProtocol.self) { resolver in
            MoyaNetworkManager(networkProvider: resolver.resolve(MoyaProvider<MultiTarget>.self)!)
        }
        container.register(UserNetworkingServiceProtocol.self) { resolver in
            UserApiService(provider: resolver.resolve(MoyaProvider<MultiTarget>.self)!,
                           authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                           handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            DataApiService(provider: resolver.resolve(MoyaProvider<MultiTarget>.self)!,
                           authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                           handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(AppealsRepoProtocol.self) { resolver in
            AppealsRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                        authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                        handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!)
        }
        container.register(AdminNetworkingServiceProtocol.self) { resolver in
            AdminApiService(provider: resolver.resolve(MoyaProvider<MultiTarget>.self)!,
                            authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                            handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
    }
}
