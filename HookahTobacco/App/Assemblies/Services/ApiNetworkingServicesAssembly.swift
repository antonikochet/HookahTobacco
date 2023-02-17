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
        container.register(ApiServices.self) { resolver in
            ApiServices(apiProvider: resolver.resolve(NetworkingProviderProtocol.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            resolver.resolve(ApiServices.self)!
        }
    }
}
