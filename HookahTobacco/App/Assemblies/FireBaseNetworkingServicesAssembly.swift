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
        container.register(SetDataNetworkingServiceProtocol.self) { r in
            FireBaseSetNetworkingService(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetDataNetworkingServiceProtocol.self) { r in
            FireBaseGetNetworkingService(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(GetImageNetworkingServiceProtocol.self) { r in
            FireBaseGetImageNetworingService(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
        container.register(SetImageNetworkingServiceProtocol.self) { r in
            FireBaseSetImageNetworkingService(handlerErrors: r.resolve(NetworkHandlerErrors.self)!)
        }
    }
}
