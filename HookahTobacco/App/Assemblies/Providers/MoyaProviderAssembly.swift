//
//  MoyaProviderAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Swinject
import Moya
import HookahTobaccoCore
import HookahTobaccoNetwork

class MoyaProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { resolver in
            let authSettings = resolver.resolve(AuthSettingsProtocol.self)!
            let plugins: [PluginType] = [
                AuthorizationPlugin(authGettingProtocol: authSettings),
                HandlerErrorPlugin()
            ]
            return MoyaProvider<MultiTarget>.makeWithPlugins(plugins)
        }
    }
}
