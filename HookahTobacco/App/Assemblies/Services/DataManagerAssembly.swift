//
//  DataManagerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import Swinject

class DataManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DataManager.self) { resolver in
            resolver.resolve(AdminDataManager.self)!
        }
        .inObjectScope(.container)

        container.register(DataManagerProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
        container.register(ObserverProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
    }
}
