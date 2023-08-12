//
//  UserDefaultsServiceAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import Swinject

class UserDefaultsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserDefaultsService.self) { _ in
            UserDefaultsService()
        }
        .inObjectScope(.container)

        container.register(UserDefaultsServiceProtocol.self) { resolver in
            resolver.resolve(UserDefaultsService.self)!
        }

        container.register(AuthSettingsProtocol.self) { resolver in
            resolver.resolve(UserDefaultsService.self)!
        }
    }
}
