//
//  AdminRepoAssembly.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Swinject
import HookahTobaccoNetwork
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

final class AdminRepoAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AdminTasteTypeRepoProtocol.self) { resolver in
            AdminTasteTypeRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                               authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                               handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!,
                               sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(AdminTasteRepoProtocol.self) { resolver in
            AdminTasteRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                           authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                           handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!,
                           sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
        container.register(AdminTobaccoLineRepoProtocol.self) { resolver in
            AdminTobaccoLineRepo(networkManager: resolver.resolve(NetworkManagerProtocol.self)!,
                                 authSettings: resolver.resolve(AuthSettingsProtocol.self)!,
                                 handlerErrors: resolver.resolve(HookahTobaccoNetwork.NetworkHandlerErrors.self)!,
                                 sendingErrorInMetric: resolver.resolve(SendingMetricErrorProtocol.self)!)
        }
    }
}
