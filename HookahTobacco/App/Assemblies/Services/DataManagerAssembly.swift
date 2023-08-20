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
            DataManager(
                getDataNetworkingService: resolver.resolve(GetDataNetworkingServiceProtocol.self)!,
                dataBaseService: resolver.resolve(DataBaseServiceProtocol.self)!,
                userDefaultsService: resolver.resolve(UserSettingsServiceProtocol.self)!,
                imageService: resolver.resolve(ImageStorageServiceProtocol.self)!
            )
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
