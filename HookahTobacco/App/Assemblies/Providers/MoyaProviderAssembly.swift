//
//  MoyaProviderAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Swinject
import Moya

class MoyaProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MoyaProvider.self) { resolver in
            let authSettings = resolver.resolve(AuthSettingsProtocol.self)!
            let plagins: [PluginType] = [
                AuthorizationPlugin(authSettings: authSettings),
                HandlerErrorPlugin()
            ]
            return MoyaProvider<MultiTarget>.makeWithPlugins(plagins)
        }
    }
}
