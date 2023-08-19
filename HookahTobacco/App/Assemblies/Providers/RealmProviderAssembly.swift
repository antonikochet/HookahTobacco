//
//  RealmProviderAssembly.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Swinject
import Moya

class RealmProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTRealmProtocol.self) { _ in
            HTRealm()
        }
        container.register(DataBaseHandlerErrorsProtocol.self) { _ in
            RealmHandlerErrors()
        }
        container.register(RealmProviderProtocol.self) { resolver in
            RealmProvider(htRealm: resolver.resolve(HTRealmProtocol.self)!)
        }
    }
}
