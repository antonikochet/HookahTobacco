//
//  MultiMoyaProvider.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import Moya

public typealias PluginType = Moya.PluginType

public final class MultiMoyaProvider: MoyaProvider<MultiTarget> {
    static var defaultSession: Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return Session(configuration: configuration, startRequestsImmediately: false)
    }

    static public func makeWithPlugins(_ additionalPlugins: [PluginType]) -> MultiMoyaProvider {
        var plugins: [PluginType] = []

        #if DEBUG
        let loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        plugins.append(loggerPlugin)
        #endif

        plugins.append(contentsOf: additionalPlugins)

        return MultiMoyaProvider(session: defaultSession, plugins: plugins)
    }
}
