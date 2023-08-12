//
//  AdminDataManagerAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.12.2022.
//

import Foundation
import Swinject

class AdminDataManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AdminDataManager.self) { resolver in
            AdminDataManager(
                getDataNetworkingService: resolver.resolve(GetDataNetworkingServiceProtocol.self)!,
                dataBaseService: resolver.resolve(DataBaseServiceProtocol.self)!,
                userDefaultsService: resolver.resolve(UserSettingsServiceProtocol.self)!,
                setDataNetworkingService: resolver.resolve(SetDataNetworkingServiceProtocol.self)!
            )
        }
        .inObjectScope(.container)

        container.register(AdminDataManagerProtocol.self) { resolver in
            resolver.resolve(AdminDataManager.self)!
        }
    }
}
