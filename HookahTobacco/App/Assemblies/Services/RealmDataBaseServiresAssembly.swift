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
        
        container.register(HTRealmProtocol.self) { r in
            HTRealm()
        }
        container.register(DataBaseHandlerErrorsProtocol.self) { r in
            RealmHandlerErrors()
        }
        container.register(RealmProviderProtocol.self) { r in
            RealmProvider(htRealm: r.resolve(HTRealmProtocol.self)!,
                          handlerErrors: r.resolve(DataBaseHandlerErrorsProtocol.self)!)
        }
        container.register(DataBaseServiceProtocol.self) { r in
            RealmDataBaseService(realmProvider: r.resolve(RealmProviderProtocol.self)!)
        }
    }
}
