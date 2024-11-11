//
//  UserDefaultsServiceAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import Swinject
import HookahTobaccoCore

class UserSettingsServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LocalStorageProtocol.self) { _ in
            UserDefaultsStorage(userDefaults: .standard)
        }
        
        container.register(LocalSecurityStorageProtocol.self) { _ in
            KeychainStorage(service: "ru.kochetkovAnton.HookahTobacco") // TODO: - вероятней всего заменить на константу из Info.plist
        }
        
        container.register(UserSettingsService.self) { resolver in
            UserSettingsService(
                localStorage: resolver.resolve(LocalStorageProtocol.self)!,
                localSecurityStorage: resolver.resolve(LocalSecurityStorageProtocol.self)!)
        }
        .inObjectScope(.container)

        container.register(AuthSettingsProtocol.self) { resolver in
            resolver.resolve(UserSettingsService.self)!
        }
    }
}
