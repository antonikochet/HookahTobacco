//
//  RealmDataBaseServiresAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 21.11.2022.
//

import Foundation
import Swinject

class RealmDataBaseServiresAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HTRealmProtocol.self) { _ in
            HTRealm()
        }
        container.register(DataBaseHandlerErrorsProtocol.self) { _ in
            RealmHandlerErrors()
        }
        container.register(RealmProviderProtocol.self) { resolver in
            RealmProvider(htRealm: resolver.resolve(HTRealmProtocol.self)!,
                          handlerErrors: resolver.resolve(DataBaseHandlerErrorsProtocol.self)!)
        }
        container.register(DataBaseServiceProtocol.self) { resolver in
            RealmDataBaseService(realmProvider: resolver.resolve(RealmProviderProtocol.self)!)
        }
    }
}
