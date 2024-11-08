//
//  AuthServiceAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Swinject
import Moya
import HookahTobaccoCore

class AuthServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthService.self) { resolver in
            let authRepo = resolver.resolve(AuthorizationRepoProtocol.self)!
            let registrationRepo = resolver.resolve(RegistrationRepoProtocol.self)!
            let settings = resolver.resolve(AuthSettingsProtocol.self)!
            return AuthService(authRepo: authRepo,
                               registrationRepo: registrationRepo,
                               settings: settings)
        }
        .inObjectScope(.container)

        container.register(AuthServiceProtocol.self) { resolver in
            resolver.resolve(AuthService.self)!
        }
        container.register(RegistrationServiceProtocol.self) { resolver in
            resolver.resolve(AuthService.self)!
        }
    }
}
