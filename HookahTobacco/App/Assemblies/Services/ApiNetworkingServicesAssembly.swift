//
//  ApiNetworkingServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.02.2023.
//

import Foundation
import Swinject

class ApiNetworkingServicesAssembly: Assembly {
    func assemble(container: Container) {

        container.register(NetworkingProviderProtocol.self) { _ in
            NetworkingProvider()
        }
        container.register(NetworkHandlerErrors.self) { _ in
            ApiHandlerErrors()
        }
        container.register(ApiServices.self) { resolver in
            ApiServices(apiProvider: resolver.resolve(NetworkingProviderProtocol.self)!,
                        handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            resolver.resolve(ApiServices.self)!
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            resolver.resolve(ApiServices.self)!
        }
        container.register(GetImageNetworkingServiceProtocol.self) { resolver in
            resolver.resolve(ApiServices.self)!
        }
        container.register(SetImageNetworkingServiceProtocol.self) { resolver in
            resolver.resolve(ApiServices.self)!
        }
    }
}
