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
        container.register(UserSettingsService.self) { _ in
            UserSettingsService()
        }
        .inObjectScope(.container)

        container.register(UserSettingsServiceProtocol.self) { resolver in
            resolver.resolve(UserSettingsService.self)!
        }

        container.register(AuthSettingsProtocol.self) { resolver in
            resolver.resolve(UserSettingsService.self)!
        }
    }
}
