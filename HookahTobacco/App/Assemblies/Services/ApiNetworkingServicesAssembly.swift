//
//  ApiNetworkingServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Swinject
import Moya

class ApiNetworkingServicesAssembly: Assembly {
    func assemble(container: Container) {

        container.register(NetworkHandlerErrors.self) { _ in
            ApiHandlerErrors()
        }
        container.register(UserNetworkingServiceProtocol.self) { resolver in
            UserApiService(provider: resolver.resolve(MoyaProvider.self)!,
                           handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            DataApiService(provider: resolver.resolve(MoyaProvider.self)!,
                           handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(AdminNetworkingServiceProtocol.self) { resolver in
            AdminApiService(provider: resolver.resolve(MoyaProvider.self)!,
                            handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
    }
}
