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
        container.register(DataBaseServiceProtocol.self) { resolver in
            RealmDataBaseService(realmProvider: resolver.resolve(RealmProviderProtocol.self)!)
        }
    }
}
