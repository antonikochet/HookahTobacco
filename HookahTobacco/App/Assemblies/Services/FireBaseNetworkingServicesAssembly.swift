//
//  FireBaseNetworkingServicesAssembly.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import Foundation
import Swinject

class FireBaseNetworkingServicesAssembly: Assembly {
    func assemble(container: Container) {

        container.register(NetworkHandlerErrors.self) { _ in
            FireBaseHandlerErrors()
        }
        container.register(SetDataNetworkingServiceProtocol.self) { resolver in
            FireBaseSetNetworkingService(handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { resolver in
            FireBaseGetNetworkingService(handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetImageNetworkingServiceProtocol.self) { resolver in
            FireBaseGetImageNetworingService(handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(SetImageNetworkingServiceProtocol.self) { resolver in
            FireBaseSetImageNetworkingService(handlerErrors: resolver.resolve(NetworkHandlerErrors.self)!)
        }
    }
}
