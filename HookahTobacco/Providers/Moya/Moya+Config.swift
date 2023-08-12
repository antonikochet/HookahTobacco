//
//  Moya+Config.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.07.2023.
//

import Foundation
import Moya

extension MoyaProvider {

    static var defaultSession: Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return Session(configuration: configuration, startRequestsImmediately: false)
    }

    static func makeWithPlugins(_ additionalPlugins: [PluginType]) -> MoyaProvider {
        var plugins: [PluginType] = []

        #if DEBUG
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        plugins.append(loggerPlugin)
        #endif

        plugins.append(contentsOf: additionalPlugins)

        return MoyaProvider(session: defaultSession, plugins: plugins)
    }
}
