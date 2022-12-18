//
//  AuthService.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//

import Foundation
import Swinject

class FirebaseAuthServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AuthHandlerErrors.self) { _ in
            FirebaseAuthHandlerErrors()
        }
        container.register(FirebaseAuthService.self) { resolver in
            FirebaseAuthService(handlerErrors: resolver.resolve(AuthHandlerErrors.self)!)
        }
        .inObjectScope(.container)

        container.register(AuthServiceProtocol.self) { resolver in
            resolver.resolve(FirebaseAuthService.self)!
        }
        container.register(RegistrationServiceProtocol.self) { resolver in
            resolver.resolve(FirebaseAuthService.self)!
        }
    }
}
