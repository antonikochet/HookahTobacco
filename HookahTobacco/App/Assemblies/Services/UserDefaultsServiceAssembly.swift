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
        container.register(UserDefaultsServiceProtocol.self) { _ in
            UserDefaultsService()
        }
    }
}
