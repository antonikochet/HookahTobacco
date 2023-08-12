//
//  ApiAuthServiceAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Swinject
import Moya

class ApiAuthServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthHandlerErrors.self) { _ in
            ApiAuthHandlerErrors()
        }
        container.register(ApiAuthServices.self) { resolver in
            let provider = resolver.resolve(MoyaProvider<MultiTarget>.self)!
            let settings = resolver.resolve(AuthSettingsProtocol.self)!
            let handlerErrors = resolver.resolve(AuthHandlerErrors.self)!
            return ApiAuthServices(provider: provider,
                                   settings: settings,
                                   handlerErrors: handlerErrors)
        }
        .inObjectScope(.container)

        container.register(AuthServiceProtocol.self) { resolver in
            resolver.resolve(ApiAuthServices.self)!
        }
        container.register(RegistrationServiceProtocol.self) { resolver in
            resolver.resolve(ApiAuthServices.self)!
        }
    }
}
