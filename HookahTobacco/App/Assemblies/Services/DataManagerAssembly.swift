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
            DataManager.init(
                getDataNetworkingService: resolver.resolve(GetDataNetworkingServiceProtocol.self)!,
                getImageNetworingService: resolver.resolve(GetImageNetworkingServiceProtocol.self)!,
                dataBaseService: resolver.resolve(DataBaseServiceProtocol.self)!,
                imageService: resolver.resolve(ImageServiceProtocol.self)!,
                userDefaultsService: resolver.resolve(UserDefaultsServiceProtocol.self)!
            )
        }
        .inObjectScope(.container)

        container.register(DataManagerProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
        container.register(ImageManagerProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
        container.register(UpdateDataManagerObserverProtocol.self) { resolver in
            resolver.resolve(DataManager.self)!
        }
    }
}
